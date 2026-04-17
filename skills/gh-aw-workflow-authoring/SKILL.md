---
name: gh-aw-workflow-authoring
description: "Create new GitHub Agentic Workflows, shared gh-aw components, and safe edits to workflow prompts or frontmatter with the right compile, security, tool patterns, and Peli's Agent Factory reuse rules."
---

# GH-AW Workflow Authoring

Use this skill when the user wants to create a new Github Agentic Workflow, scaffold a shared gh-aw component, or make deliberate authoring changes to workflow files.

## Start Here

Before designing anything, consult `references/authoring-sources.md`.

If the task depends on local gh-aw commands such as `gh aw init`, `gh aw compile`, `gh aw add-wizard`, `gh aw validate`, `gh aw logs`, `gh aw audit`, or `gh aw mcp inspect`, verify that gh-aw is available before relying on that path. Try `gh aw version` first; if that fails, check `gh extension list` for `github/gh-aw`. If gh-aw is not available, warn the user immediately, do not imply local compile or add-wizard steps were performed, and guide the user with the smallest install step needed.

Use Peli's Agent Factory as the first routing check for workflow requests:

- If the user's requested workflow already exists in the Agent Factory index, start from that ready-to-use workflow source instead of authoring from scratch.
- If there is no exact match but there is a close factory workflow or category write-up, use that source and the related blog guidance as inspiration, then adapt only the parts needed for the user's repository and constraints.
- If the request is clearly outside the factory catalog, continue with normal bespoke authoring.

## Example Prompts

- "Create a new gh-aw workflow that triages new issues and posts a safe summary comment."
- "Scaffold a shared gh-aw component for reusable GitHub issue lookup logic."
- "Add a label_command workflow that generates a release readiness summary from repository data."

Anchor the starting point before authoring:

- If the repository should support GitHub.com or mobile-agent authoring, initialize it first with `gh aw init` or the upstream `install.md` prompt flow.
- If the user wants the fastest path to a known-good workflow, prefer `gh extension install github/gh-aw` and `gh aw add-wizard <source>` to add a sample plus its lock file.
- If the user wants a bespoke workflow through an interactive coding agent, use the upstream `create.md` prompt and author in `.github/workflows/`.

Route the task first:

- Exact match in Peli's Agent Factory: reuse that upstream workflow `.md` source as the starting point, then adapt it deliberately.
- Partial match in Peli's Agent Factory: use the closest workflow and related blog/category article as inspiration, but do not force an ill-fitting copy.
- New workflow from scratch: use the upstream authoring flow from `create.md` and `create-agentic-workflow.md`.
- Shared import or MCP wrapper: use `create-shared-agentic-workflow.md`.
- Existing workflow edits or fixes: prefer the `gh-aw-workflow-maintenance` skill.
- Review-only work: prefer the `gh-aw-workflow-review` skill.

## Authoring Rules

1. Treat gh-aw workflows as markdown source files in `.github/workflows/*.md` that compile to `.lock.yml` files.
2. Keep setup assumptions explicit:
   - The `gh` CLI plus the `github/gh-aw` extension are the default local authoring path; verify gh-aw availability before depending on local CLI flows.
   - The repository needs GitHub Actions enabled and write access for installation and run setup.
   - The chosen engine must have its matching secret configured. Copilot uses `COPILOT_GITHUB_TOKEN`, Claude uses `ANTHROPIC_API_KEY`, and Codex uses `OPENAI_API_KEY`.
   - If the workflow is not using Copilot, adjust `engine:` in frontmatter rather than assuming the default engine is correct.
3. Separate prompt edits from configuration edits:
   - Markdown body changes do not require recompilation.
   - YAML frontmatter changes do require recompilation.
4. Keep the agent job read-only. Route all GitHub writes through `safe-outputs:`.
5. For GitHub API reads, use `tools.github.toolsets`. Do not design workflows around direct access to `api.github.com`.
6. Prefer minimal frontmatter. Avoid default-only fields unless there is a reason to override them.
7. Infer network ecosystems from repository language when builds, installs, or tests are involved. Do not rely on `network: defaults` alone for code workflows.
8. Respect gh-aw's staged execution model and orchestration boundaries. Prefer supported patterns such as `call-workflow` and `dispatch-workflow` when they fit; if the request needs long waits on external events, unsupported rollback choreography, matrix-style coordination, or arbitrary cross-job state passing, recommend traditional GitHub Actions or a hybrid design.
9. For command-style workflows, choose deliberately:
   - `slash_command` for conversational, argument-carrying triggers.
   - `label_command` for visible, one-shot UI triggers.
10. Prefer fuzzy schedules like `daily on weekdays` or `weekly` over fixed cron times when the use case allows it.
11. For preview-first rollouts or risky write paths, consider `safe-outputs.staged: true` before enabling real writes.
12. Reach for newer built-ins instead of ad hoc workarounds when they fit: `mcp-scripts:` for small custom tools, `threat-detection:` for additional output scrutiny, `cache-memory:` or `repo-memory:` for retained context, `qmd:` for local documentation search, and `playwright:` for browser automation.
13. In prompts, tell the agent to emit `noop` when it completed the analysis and there is intentionally nothing to do.
14. When authoring manually, always create and commit the pair together: `.github/workflows/<name>.md` and `.github/workflows/<name>.lock.yml`.
15. When frontmatter changes require recompilation, recompile the gh-aw markdown source first. Then run `actionlint` against the generated `.lock.yml` when it is available. Do not run it against the gh-aw markdown source, and say explicitly if `actionlint` was not available.

## Workflow Design Process

1. Refresh against current docs using `llms.txt` or `llms-full.txt`, then check Peli's Agent Factory for an exact or adjacent workflow before drafting a bespoke design.
2. Confirm the authoring path:
   - If the chosen path depends on local gh-aw commands, verify gh-aw availability first and warn immediately if it is missing.
   - Initialized repo for GitHub.com or mobile `/agent agentic-workflows` usage.
   - Coding-agent flow using the upstream `create.md` prompt.
   - Manual editing plus local compile.
3. If a factory workflow is a fit, identify whether it should be reused mostly as-is or remixed around the user's trigger, write path, repo language, and external systems.
4. Identify the trigger, GitHub read scope, external systems, write side effects, repo language, and whether built-ins such as `call-workflow`, `dispatch-workflow`, staged mode, or `threat-detection:` are part of the design.
5. Draft the smallest frontmatter that satisfies the use case.
6. Draft a prompt body that is explicit about task, constraints, and safe outputs.
7. Recompile the workflow source after frontmatter changes and fix all gh-aw validation errors before stopping.
8. Run `actionlint` against the generated `.github/workflows/<name>.lock.yml` when it is available, and fix any resulting workflow-YAML errors in the source before stopping.
9. Tell the user how to trigger the first run, typically from the Actions tab or `gh aw run <workflow-name>`.

## Common Patterns

- Community-facing issue triage: consider `on.roles: all`, `tools.github.toolsets: [default]`, safe outputs for comments and labels, and sanitized context text.
- Daily improvers or reporters: prefer fuzzy weekday scheduling, `skip-if-match` to avoid duplicates, and `close-older-*` options for recurring outputs.
- Same-repo orchestration: prefer `call-workflow` for typed same-run worker selection and `dispatch-workflow` for asynchronous same-repo follow-up work before inventing bespoke orchestration.
- Shared components: keep them focused, prefer containerized MCP servers, keep read-only tool allowlists tight, and document source links in XML comments or reference material.
- Preview-first rollouts: enable staged mode while validating prompts and safe outputs, then remove it when the workflow is ready to write for real.
- Richer context and browser work: consider `qmd:`, `cache-memory:`, `repo-memory:`, or `playwright:` when the workflow needs local docs search, historical context, or controlled browser interaction.
- Prompt-only refinements: update the markdown body only and do not force a needless recompile.
- Quickstart bootstrap requests: prefer `gh aw add-wizard` when the user wants a proven example to customize, then edit the markdown body before touching frontmatter.
- Repeated analysis or reporting: consider `cache-memory:` or `repo-memory:` when historical context materially improves the workflow's decisions.
- Factory-first requests: when the ask maps cleanly to a factory workflow such as triage, PR review, documentation upkeep, fault investigation, or analytics, adapt the existing upstream workflow before inventing a new one.

## Deliverables

- One focused workflow or shared component per task unless the user explicitly wants a bundle.
- Up-to-date links back to the authoritative gh-aw docs and raw prompt files.
- If the workflow came from Peli's Agent Factory, state whether it was an exact-match reuse or an inspired-by adaptation.
- Clear distinction between changes that need recompilation and those that do not.
- Clear statement of whether compile validation and `actionlint` verification were run, skipped, or blocked.