---
name: gh-aw-workflow-authoring
description: "Create new GitHub Agentic Workflows, shared gh-aw components, and safe edits to workflow prompts or frontmatter with the right compile, security, and tool patterns."
---

# GH-AW Workflow Authoring

Use this skill when the user wants to create a new gh-aw workflow, scaffold a shared gh-aw component, or make deliberate authoring changes to workflow files.

## Start Here

Before designing anything, consult `references/authoring-sources.md`.

Route the task first:

- New workflow from scratch: use the upstream authoring flow from `create.md` and `create-agentic-workflow.md`.
- Shared import or MCP wrapper: use `create-shared-agentic-workflow.md`.
- Existing workflow edits or fixes: prefer the `gh-aw-workflow-maintenance` skill.
- Review-only work: prefer the `gh-aw-workflow-review` skill.

## Authoring Rules

1. Treat gh-aw workflows as markdown source files in `.github/workflows/*.md` that compile to `.lock.yml` files.
2. Separate prompt edits from configuration edits:
   - Markdown body changes do not require recompilation.
   - YAML frontmatter changes do require recompilation.
3. Keep the agent job read-only. Route all GitHub writes through `safe-outputs:`.
4. For GitHub API reads, use `tools.github.toolsets`. Do not design workflows around direct access to `api.github.com`.
5. Prefer minimal frontmatter. Avoid default-only fields unless there is a reason to override them.
6. Infer network ecosystems from repository language when builds, installs, or tests are involved. Do not rely on `network: defaults` alone for code workflows.
7. Respect gh-aw's single-job execution model. If the request needs waiting, fan-out orchestration, rollback orchestration, or cross-job state passing, recommend traditional GitHub Actions or a hybrid design.
8. For command-style workflows, choose deliberately:
   - `slash_command` for conversational, argument-carrying triggers.
   - `label_command` for visible, one-shot UI triggers.
9. Prefer fuzzy schedules like `daily on weekdays` or `weekly` over fixed cron times when the use case allows it.
10. In prompts, tell the agent to emit `noop` when it completed the analysis and there is intentionally nothing to do.

## Workflow Design Process

1. Refresh against current docs using `llms.txt` or `llms-full.txt`, then use the sitemap files to locate newer pages if needed.
2. Identify the trigger, GitHub read scope, external systems, write side effects, and repo language.
3. Draft the smallest frontmatter that satisfies the use case.
4. Draft a prompt body that is explicit about task, constraints, and safe outputs.
5. If working inside a real gh-aw repository, compile after frontmatter changes and fix all validation errors before stopping.

## Common Patterns

- Community-facing issue triage: consider `on.roles: all`, `tools.github.toolsets: [default]`, safe outputs for comments and labels, and sanitized context text.
- Daily improvers or reporters: prefer fuzzy weekday scheduling, `skip-if-match` to avoid duplicates, and `close-older-*` options for recurring outputs.
- Shared components: keep them focused, prefer containerized MCP servers, keep read-only tool allowlists tight, and document source links in XML comments or reference material.
- Prompt-only refinements: update the markdown body only and do not force a needless recompile.

## Deliverables

- One focused workflow or shared component per task unless the user explicitly wants a bundle.
- Up-to-date links back to the authoritative gh-aw docs and raw prompt files.
- Clear distinction between changes that need recompilation and those that do not.