---
name: gh-aw-workflow-maintenance
description: "Edit, fix, debug, update, and upgrade existing gh-aw workflows with the correct recompile behavior, strict validation, and run-analysis workflow."
---

# GH-AW Workflow Maintenance

Use this skill when the user wants to edit an existing gh-aw workflow, fix a broken workflow, debug a run, upgrade workflows to a newer gh-aw version, or apply targeted maintenance to shared components.

## Start Here

Before changing anything, consult `references/maintenance-sources.md`.

Then classify the work:

- Prompt-only behavior update: edit only the markdown body.
- Frontmatter/config change: edit YAML, then recompile.
- Run failure or missing tool investigation: use the debug flow.
- Bulk upgrade or deprecation cleanup: use the upgrade flow.

## Maintenance Rules

1. Make small, surgical changes. Do not rewrite frontmatter unless the change truly requires it.
2. Preserve existing patterns unless the task is explicitly a refactor or upgrade.
3. If the change only touches the markdown body, do not force recompilation.
4. If the change touches frontmatter, compile and fix all resulting validation errors before stopping.
5. Prefer strict validation and secure defaults over relaxing guardrails.
6. Keep GitHub writes inside `safe-outputs:`. Do not add direct write permissions to the agent job.
7. Use `toolsets:` for GitHub tools. Do not reintroduce unsupported or deprecated patterns such as `mode: remote` for GitHub tools in normal workflow designs.

## Recommended Flows

### Existing Workflow Updates

1. Read the current workflow and decide whether the change is body-only or frontmatter.
2. For body-only edits, update the prompt and stop there unless the user asked for validation.
3. For frontmatter edits, change the smallest possible YAML surface.
4. Recompile and validate. Prefer `gh aw compile --strict` or `gh aw validate` when available.

### Debugging Failures

1. If the user gives a run URL or run ID, audit that run first.
2. Use `gh aw audit <run-id> --json` or the equivalent `agentic-workflows` MCP tool.
3. Check for:
   - Missing tools
   - Safe-output mismatches
   - Network/firewall denials
   - MCP startup failures
   - Permission or auth failures
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