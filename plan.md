## Plan: Release Includes Changelog

Make publish-release.yml the canonical path for changelog inclusion in the released tag, and convert update-changelog-file.yml into a manual repair workflow that re-renders expected changelog content from release metadata and only writes when drift exists. Share two narrow primitives across both workflows: one renderer for markdown generation and one git-writeback action for commit-if-changed behavior.

**Steps**
1. Phase 1: Reassign workflow ownership.
2. Update publish-release.yml so published releases, not post-release repair automation, own CHANGELOG.md inclusion in the tagged commit.
3. Keep draft behavior separate: when `inputs.draft` is true, do not render or write CHANGELOG.md and do not run changelog writeback.
4. Remove the `release.published` trigger from update-changelog-file.yml.
5. Keep update-changelog-file.yml as `workflow_dispatch`-only repair/backfill tooling.
6. Add an explicit branch input to update-changelog-file.yml so repair runs target the intended branch instead of relying on `release.target_commitish`.
7. Phase 2: Extract shared rendering.
8. Add a composite action under `.github/actions` that accepts tag, title, release URL, published date, prerelease flag, previous tag, main body markdown, and optional appendix markdown.
9. Make that action output a rendered footer, rendered release body, and rendered changelog entry.
10. Move shared markdown formatting into that action: empty-body fallback, prerelease suffix, compare link, release-page link, and footer stripping or normalization.
11. Use checked-in template files inside the action so markdown shape is editable without duplicating shell blocks across workflows.
12. In publish-release.yml, construct the expected release URL from the deterministic tag URL pattern before the release exists and pass it into the renderer.
13. Phase 3: Extract shared git writeback.
14. Add a second composite action under `.github/actions` for git writeback with a narrow contract only: verify attached branch state, configure bot identity, stage file paths, commit only when there is a diff, and push.
15. Keep branch selection, drift detection, content generation, and release sequencing in the workflows, not in the writeback action.
16. Phase 4: Refactor publish-release.
17. In publish-release.yml, keep tag resolution and target-branch validation.
18. When `draft` is false, generate release notes first so the renderer uses the intended release content rather than a later housekeeping commit.
19. Render the changelog entry, merge it into CHANGELOG.md, and invoke the shared git-writeback action with CHANGELOG.md and the release commit message.
20. After that push succeeds, create the GitHub release from the updated branch `HEAD` so the new tag contains the changelog commit.
21. If the explicit commit appendix must exclude the changelog housekeeping commit, compute that appendix before writing CHANGELOG.md and pass the frozen appendix markdown into the renderer.
22. Phase 5: Refactor update-changelog-file.
23. In update-changelog-file.yml, keep only `workflow_dispatch` inputs for release or tag selection and target branch.
24. Replace inline heading, footer, and body assembly with the shared renderer.
25. Preserve dedupe behavior so repeated repair runs remain idempotent.
26. Render the expected changelog result, compare it to the current CHANGELOG.md, and record whether drift exists.
27. If there is no drift, exit successfully without writing or pushing.
28. If drift exists, write the rendered result and invoke the shared git-writeback action to push the repair commit.
29. Phase 6: Prevent overlapping writers.
30. Give both workflows a shared concurrency namespace keyed by target branch.
31. Keep `cancel-in-progress: false` so release and repair runs serialize instead of interrupting each other.
32. Phase 7: Verify.
33. Run `actionlint` on both workflows and both new composite actions.
34. Run publish-release.yml with an explicit non-draft test tag on a safe branch and confirm the changelog commit lands before release creation.
35. Verify the created tag contains the updated CHANGELOG.md.
36. Verify the GitHub release body matches the shared renderer output and links to the expected release URL.
37. Run publish-release.yml with `draft: true` and confirm no changelog mutation occurs.
38. Run update-changelog-file.yml against an already-correct release and confirm it exits as a no-op.
39. Run update-changelog-file.yml against a controlled stale state and confirm it repairs CHANGELOG.md and pushes exactly one commit.
40. Run overlapping publish and repair attempts for the same branch and confirm concurrency serializes them.

**Relevant files**
- publish-release.yml — canonical published-release workflow; adds pre-release changelog writeback and explicitly skips writeback for drafts.
- update-changelog-file.yml — manual repair workflow with explicit branch input and repair-if-drift behavior.
- New composite action under `.github/actions` for shared markdown rendering and template ownership.
- New composite action under `.github/actions` for shared git writeback.

**Verification**
1. Lint both workflows and both composite actions with `actionlint`.
2. Publish one non-draft test release and confirm the changelog commit is pushed before release creation.
3. Inspect the tagged commit and verify CHANGELOG.md includes the new entry.
4. Inspect the release page and verify the release body matches the renderer output and expected links.
5. Publish one draft release and confirm no CHANGELOG.md mutation occurs.
6. Run the repair workflow on an already-correct branch and confirm no-op behavior.
7. Run the repair workflow on a stale branch and confirm one repair commit is pushed.
8. Verify same-branch publish and repair runs serialize under the shared concurrency group.

**Decisions**
- CHANGELOG.md must be written before `gh release create` so the released tag contains the changelog update.
- Draft releases do not mutate CHANGELOG.md.
- publish-release.yml owns canonical changelog inclusion for published releases.
- update-changelog-file.yml is manual repair/backfill only.
- Shared markdown rendering is required.
- Shared git writeback is also part of the plan, but it must remain a small side-effect primitive rather than absorbing workflow logic.
- Repair behavior is conditional: compare rendered output to the current file and only write when drift exists.
- update-changelog-file.yml needs an explicit branch input once release-triggered context is removed.
- Both workflows share a branch-scoped concurrency namespace to prevent overlapping writes.

**Further Considerations**
1. If you want release notes to exclude the changelog housekeeping commit from the explicit commit appendix, freeze that appendix before writing CHANGELOG.md.
2. If manual repairs remain rare, update-changelog-file.yml can later be simplified further into a minimal maintenance workflow.
