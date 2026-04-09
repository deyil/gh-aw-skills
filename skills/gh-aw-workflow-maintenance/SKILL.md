---
name: gh-aw-workflow-maintenance
description: "Edit, fix, debug, update, and upgrade existing Github Agentic Workflows (gh-aw) with the correct recompile behavior, strict validation, run-analysis workflow, and factory-baseline comparisons when relevant."
---

# GH-AW Workflow Maintenance

Use this skill when the user wants to edit an existing Github Agentic Workflow, fix a broken workflow, debug a run, upgrade workflows to a newer gh-aw version, or apply targeted maintenance to shared components.

## Start Here

Before changing anything, consult `references/maintenance-sources.md`.

If the requested behavior or regression aligns with a workflow in Peli's Agent Factory, compare against that upstream workflow first:

- Exact match: use the factory workflow source as the baseline for what the workflow should look like now.
- Near match: use the closest factory workflow and related write-up as inspiration for the fix, but keep the repository's own requirements primary.

## Example Prompts

- "Update the existing gh-aw workflow to use a new engine secret and recompile the lock file."
- "Fix the failing gh-aw run for this workflow using the run URL and the current source files."
- "Upgrade all gh-aw workflows in the repository to the latest supported patterns without changing prompt-only behavior."

Confirm the operational baseline before editing:

- The active workflow should exist as both `.github/workflows/<name>.md` and `.github/workflows/<name>.lock.yml`.
- If the repository was initialized for GitHub.com or mobile authoring, related bootstrap artifacts such as `.github/agents/agentic-workflows.agent.md` may also be part of the expected setup.
- Engine-specific secrets and GitHub Actions availability are part of the runtime contract, so missing-run failures are not always authoring bugs.

Then classify the work:

- Prompt-only behavior update: edit only the markdown body.
- Frontmatter/config change: edit YAML, then recompile.
- Run failure or missing tool investigation: use the debug flow.
- Bulk upgrade or deprecation cleanup: use the upgrade flow.
- Factory-aligned sync or adaptation: compare the existing workflow with the exact or nearest factory workflow before editing.

## Maintenance Rules

1. Make small, surgical changes. Do not rewrite frontmatter unless the change truly requires it.
2. Preserve existing patterns unless the task is explicitly a refactor or upgrade.
3. If the change only touches the markdown body, do not force recompilation.
4. If the change touches frontmatter, compile and fix all resulting validation errors before stopping.
5. Prefer strict validation and secure defaults over relaxing guardrails.
6. Keep GitHub writes inside `safe-outputs:`. Do not add direct write permissions to the agent job.
7. Use `toolsets:` for GitHub tools. Do not reintroduce unsupported or deprecated patterns such as `mode: remote` for GitHub tools in normal workflow designs.
8. When runs fail immediately in a fresh repository, check setup first:
   - Missing engine secret
   - Wrong `engine:` value for the configured secret
   - GitHub Actions disabled
   - Sample workflow added but never recompiled after frontmatter edits
9. When the task matches a ready-to-use factory workflow, prefer aligning to that proven source over inventing a new maintenance pattern.
10. When only adjacent factory workflows exist, treat them as inspiration and extract the smallest relevant fix or pattern instead of forcing a full upstream rewrite.

## Recommended Flows

### Existing Workflow Updates

1. Read the current workflow and decide whether the change is body-only or frontmatter.
2. For body-only edits, update the prompt and stop there unless the user asked for validation.
3. For frontmatter edits, change the smallest possible YAML surface.
4. Recompile and validate. Prefer `gh aw compile --strict` or `gh aw validate` when available.
5. If the user started from a quickstart sample such as `gh aw add-wizard`, preserve the sample's working setup unless the requested behavior requires a deliberate config change.

### Factory-Derived Updates

1. Find the exact or nearest matching workflow in Peli's Agent Factory.
2. Compare the current repository workflow against that upstream source before changing anything.
3. Reuse the exact upstream structure only when the user's requested behavior truly matches it.
4. If the fit is partial, borrow the smallest useful prompt or frontmatter patterns and preserve local requirements that the factory workflow does not model.
5. Compile after frontmatter changes and verify the adapted workflow still matches the repository's engine, secrets, permissions, and triggers.

### Debugging Failures

1. If the user gives a run URL or run ID, audit that run first.
2. Use `gh aw audit <run-id> --json` or the equivalent `agentic-workflows` MCP tool.
3. Check for:
   - Missing tools
   - Safe-output mismatches
   - Network/firewall denials
   - MCP startup failures
   - Permission or auth failures
   - Missing repository initialization for the intended authoring mode
   - Missing or mismatched engine secrets
   - Excessive token usage or long runtimes
4. If the problem is tool availability, compare the requested tool name against configured `tools:` and `safe-outputs:` names.
5. Validate the fix with compile before closing the loop.

### Upgrades And Deprecations

1. Review current release or changelog guidance first.
2. Prefer `gh aw upgrade` for repository-wide upgrades.
3. Use `gh aw fix --write` for codemod-friendly migrations.
4. Recompile after fixes, then handle any remaining errors incrementally.
5. Document breaking changes and manual fixes when the task is upgrade-oriented.

## Useful Commands And Equivalents

- `gh aw compile <workflow>`
- `gh aw compile <workflow> --strict`
- `gh aw validate <workflow> --json`
- `gh aw fix --write`
- `gh aw update`
- `gh aw upgrade`
- `gh aw logs <workflow> --json`
- `gh aw audit <run-id> --json`
- `gh aw mcp inspect <workflow>`
- `gh aw health`

If the CLI is unavailable or unauthenticated in the execution environment, use the `agentic-workflows` MCP tools that mirror `compile`, `logs`, `audit`, `status`, `update`, `add`, and `mcp-inspect`.

## Common Fixes

- Missing tool calls: correct the tool name in the prompt, or enable the missing tool/safe output in frontmatter.
- Firewall denials: add the right ecosystem or domain to `network.allowed`, keeping it minimal.
- Safe-output failures: fix the `safe-outputs:` block rather than adding write permissions.
- Compile errors: run fixers first, then address schema errors precisely.
- High token use: shorten prompts, prefetch deterministic data, or add cache-memory where repeated analysis is expected.
- Quickstart customization regressions: if a user edited frontmatter on a sample workflow and skipped `gh aw compile`, regenerate the lock file before chasing deeper runtime issues.