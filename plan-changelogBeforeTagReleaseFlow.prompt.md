# Plan: Changelog-before-tag Release Flow (v2)

## TL;DR

Restructure the release pipeline so CHANGELOG.md is committed directly to the target branch **before** the tag and release are created. `sync-changelog-from-release.yml` stays self-contained, but gains a boolean input to control how notes are generated when no release body already exists: compare against the input tag/ref, or compare against current `HEAD` for a future release. It commits the changelog directly (no PR) and outputs `commit_sha` + `release_body`. `publish-release.yml` resolves the tag, calls sync-changelog with `generate_from_head: true`, then tags the resulting commit and creates the release using the same body sync-changelog produced.

---

## Phase A — Modify `sync-changelog-from-release.yml` (self-contained)

### Trigger changes

- **ADD** `workflow_call` trigger:
  - Inputs: `tag` (required string), `generate_from_head` (optional boolean, default `false`)
  - Outputs: `commit_sha`, `release_body`
- **EXTEND** `workflow_dispatch` trigger:
  - Inputs: `tag` (required string), `generate_from_head` (optional boolean, default `false`)
- **KEEP** `release.published` trigger (fallback for manual releases; ignores the boolean because the release body already exists)

### "Prepare release metadata" step — explicit generation modes

The workflow should decide its source of truth in this order:

1. **Release event** (`release.published`): use `github.event.release.*` data — existing logic, unchanged
2. **Release exists for the tag** (`workflow_dispatch` or `workflow_call`): fetch from API and use the stored release body — existing logic, unchanged
3. **Release does not exist**: generate notes according to `generate_from_head`

When `generate_from_head == true`:
- Treat the input tag as a future release label that does not exist yet
- Discover `previous_tag` by querying the latest non-draft release
- Call `POST /repos/{owner}/{repo}/releases/generate-notes` with `tag_name=$TAG`, `target_commitish=HEAD`, and `previous_tag_name=$previous_tag`
- Build the commit list from `previous_tag..HEAD`
- Construct the release URL as `https://github.com/$GITHUB_REPOSITORY/releases/tag/$TAG`

When `generate_from_head == false`:
- Treat the input tag as an existing release/tag/ref target
- If a release exists, use its stored body
- If no release exists, generate notes against the input tag/ref rather than `HEAD`
- Build the commit list from `previous_tag..$TAG`
- If `$TAG` does not exist as a resolvable git ref and there is no release for it, fail with a clear error instead of silently switching to `HEAD`

In both generation modes:
- Assemble the final body as generated notes + "Full Commit List"
- Output the assembled body for changelog insertion and for reuse by `publish-release.yml`

### Behavior changes (all triggers)

- **REMOVE**: `git checkout -B "$BRANCH_NAME"` — no feature branch creation
- **REMOVE**: "Open pull request" step entirely
- **REMOVE**: PR-related variables (`branch`) from metadata output
- **REMOVE**: `PR_URL` from summary step
- **CHANGE**: Commit directly on the checked-out branch, `git push origin HEAD`
- **ADD**: Output `commit_sha` from the commit step (`git rev-parse HEAD`); output current HEAD if `changed == false`
- **ADD**: Output `release_body` (the assembled body used for CHANGELOG) so publish-release can use the same content for the GitHub release

### Permissions

- Remove `pull-requests: write`
- Keep `contents: write`

---

## Phase B — Restructure `publish-release.yml` into 3 jobs

### Job 1: `prepare`

Lighter than before — only resolves the tag, no note generation.

1. Checkout repo with full history — unchanged
2. Capture previous release tag — unchanged
3. Resolve tag (auto-increment or explicit) — unchanged
4. Compute `release_title` — unchanged
5. Outputs: `resolved_tag`, `previous_tag`, `release_title`

### Job 2: `update-changelog` (depends on `prepare`, skipped for drafts)

- Condition: `if: inputs.draft == false`
- Calls `sync-changelog-from-release.yml` as a reusable workflow (`uses:`)
- Inputs: `tag` = resolved tag from `prepare`, `generate_from_head: true`
- Receives outputs: `commit_sha`, `release_body`

### Job 3: `publish` (depends on `prepare` + `update-changelog`)

- Condition: runs when prepare succeeded AND update-changelog succeeded or was skipped
- Create release: `gh release create $TAG --target $TARGET_SHA --title "$TITLE" --notes-file <body_file>`
  - Body: use `release_body` output from update-changelog (changelog and release stay in sync); for drafts, use `--generate-notes` as fallback
  - `--target`: use `commit_sha` from update-changelog when available; fall back to `inputs.target` for drafts
  - Pass `--prerelease` and `--draft` flags
- Print summary to `$GITHUB_STEP_SUMMARY`

### Removed from `publish-release.yml`

- "Append full commit list to release notes" step (moved to sync-changelog)
- "Trigger changelog sync workflow" step (`gh workflow run`) — replaced by `workflow_call`
- The two-step create-then-edit pattern

---

## Relevant files

- `.github/workflows/sync-changelog-from-release.yml` — add `workflow_call` trigger; add pre-release note generation path; remove branch/PR logic; commit directly; output `commit_sha` + `release_body`
- `.github/workflows/publish-release.yml` — split into 3 jobs (`prepare`, `update-changelog`, `publish`); delegate note generation to sync-changelog; use `commit_sha` for tag target; use `release_body` for release content

---

## Verification

1. `actionlint` on both modified workflow files
2. Trigger `publish-release` with a test tag (non-draft):
   - CHANGELOG.md committed to target branch before release exists
   - Release tag points to the changelog commit (`git log --oneline -1 $TAG`)
   - Release body matches changelog entry (auto-generated "What's Changed" + "Full Commit List")
3. Trigger `publish-release` with `draft: true`:
   - Changelog NOT updated
   - Draft release created on target branch HEAD with `--generate-notes`
4. Trigger `sync-changelog-from-release.yml` via `workflow_dispatch` with an existing release tag:
   - Direct commit to default branch, no PR, no feature branch
   - Fetches release body from API (path 2)
5. Create a release manually via GitHub UI:
   - `release.published` trigger fires, commits changelog directly (path 1)

---

## Decisions

- sync-changelog remains self-contained, but now has an explicit boolean mode: `generate_from_head`
- `generate_from_head: true` means treat `tag` as a future release label and generate notes against `HEAD`
- `generate_from_head: false` means treat `tag` as an existing release/tag/ref and never silently fall back to `HEAD`
- `publish-release.yml` passes `generate_from_head: true` because it resolves the tag before the actual tag/ref exists
- Changelog updated only for published releases, not drafts
- Release body for non-drafts comes from sync-changelog's output so changelog and release body are identical
- Draft releases fall back to `--generate-notes` because no changelog step runs
- Release URL in changelog can be constructed before the release exists and becomes valid moments later
- `release.published` trigger stays as fallback; GITHUB_TOKEN-created releases do not recursively trigger it
- `gh release create --target $SHA` pins the tag to the changelog commit and avoids race conditions
- No-op: if the changelog entry already exists, skip the commit and output current HEAD SHA