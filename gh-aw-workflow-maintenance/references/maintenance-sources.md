# GH-AW Maintenance Sources

Use these sources when editing, debugging, fixing, or upgrading existing gh-aw workflows.

## Machine-Readable Discovery

- llms index: https://github.github.com/gh-aw/llms.txt
- Full docs: https://github.github.com/gh-aw/llms-full.txt
- Sitemap index: https://github.github.com/gh-aw/sitemap-index.xml
- Sitemap body: https://github.github.com/gh-aw/sitemap-0.xml
- Agent Factory status index: https://github.github.com/gh-aw/agent-factory-status/
- Agent Factory workflow source tree: https://github.com/github/gh-aw/tree/main/.github/workflows

## Peli's Agent Factory

- Welcome post and rationale: https://github.github.com/gh-aw/blog/2026-01-12-welcome-to-pelis-agent-factory/
- Factory status section: https://github.github.com/gh-aw/blog/2026-01-12-welcome-to-pelis-agent-factory/#factory-status
- Meet the Workflows landing page: https://github.github.com/gh-aw/blog/2026-01-13-meet-the-workflows/
- Fault investigation workflows: https://github.github.com/gh-aw/blog/2026-01-13-meet-the-workflows-quality-hygiene/
- Documentation workflows: https://github.github.com/gh-aw/blog/2026-01-13-meet-the-workflows-documentation/
- Testing and validation workflows: https://github.github.com/gh-aw/blog/2026-01-13-meet-the-workflows-testing-validation/
- Metrics and analytics workflows: https://github.github.com/gh-aw/blog/2026-01-13-meet-the-workflows-metrics-analytics/
- Operations and release workflows: https://github.github.com/gh-aw/blog/2026-01-13-meet-the-workflows-operations-release/

Use this section when editing or fixing workflows:

- Exact factory match: compare against the upstream workflow source before making local changes.
- Near factory match: borrow the closest proven pattern or debugging approach, but keep local triggers, permissions, secrets, and outputs authoritative.

## Canonical Docs

- Overview: https://github.github.com/gh-aw/introduction/overview/
- How they work: https://github.github.com/gh-aw/introduction/how-they-work/
- Security architecture: https://github.github.com/gh-aw/introduction/architecture/
- CLI commands: https://github.github.com/gh-aw/setup/cli/
- Debugging guide: https://github.github.com/gh-aw/troubleshooting/debugging/
- Common issues: https://github.github.com/gh-aw/troubleshooting/common-issues/
- Error reference: https://github.github.com/gh-aw/troubleshooting/errors/
- Workflow structure: https://github.github.com/gh-aw/reference/workflow-structure/
- Frontmatter reference: https://github.github.com/gh-aw/reference/frontmatter/
- Tools reference: https://github.github.com/gh-aw/reference/tools/
- Safe outputs reference: https://github.github.com/gh-aw/reference/safe-outputs/
- GH-AW as MCP server: https://github.github.com/gh-aw/reference/gh-aw-as-mcp-server/

## Expanded Maintenance And Debug Index From Overview

### Guides And Operations

- Creating workflows: https://github.github.com/gh-aw/setup/creating-workflows/
- Agentic authoring: https://github.github.com/gh-aw/guides/agentic-authoring/
- Reusing workflows: https://github.github.com/gh-aw/guides/packaging-imports/
- Using custom MCPs: https://github.github.com/gh-aw/guides/mcps/
- Audit reports with agents: https://github.github.com/gh-aw/guides/audit-with-agents/
- Web search: https://github.github.com/gh-aw/guides/web-search/

### Patterns Relevant To Maintenance

- Monitoring: https://github.github.com/gh-aw/patterns/monitoring/
- MultiRepoOps: https://github.github.com/gh-aw/patterns/multi-repo-ops/
- WorkQueueOps: https://github.github.com/gh-aw/patterns/workqueue-ops/
- BatchOps: https://github.github.com/gh-aw/patterns/batch-ops/
- TrialOps: https://github.github.com/gh-aw/patterns/trial-ops/
- DispatchOps: https://github.github.com/gh-aw/patterns/dispatch-ops/
- IssueOps: https://github.github.com/gh-aw/patterns/issue-ops/
- LabelOps: https://github.github.com/gh-aw/patterns/label-ops/

### References Commonly Needed During Fixes

- Authentication: https://github.github.com/gh-aw/reference/auth/
- Cache memory: https://github.github.com/gh-aw/reference/cache-memory/
- Compilation process: https://github.github.com/gh-aw/reference/compilation-process/
- Concurrency: https://github.github.com/gh-aw/reference/concurrency/
- Custom safe outputs: https://github.github.com/gh-aw/reference/custom-safe-outputs/
- Frontmatter (full): https://github.github.com/gh-aw/reference/frontmatter-full/
- GitHub read tools: https://github.github.com/gh-aw/reference/github-tools/
- GitHub cross-repository: https://github.github.com/gh-aw/reference/cross-repository/
- Imports: https://github.github.com/gh-aw/reference/imports/
- Markdown: https://github.github.com/gh-aw/reference/markdown/
- MCP gateway: https://github.github.com/gh-aw/reference/mcp-gateway/
- MCP scripts: https://github.github.com/gh-aw/reference/mcp-scripts/
- Network access: https://github.github.com/gh-aw/reference/network/
- Playwright: https://github.github.com/gh-aw/reference/playwright/
- Rate limiting: https://github.github.com/gh-aw/reference/rate-limiting-controls/
- Releases and versioning: https://github.github.com/gh-aw/reference/releases/
- Repo memory: https://github.github.com/gh-aw/reference/repo-memory/
- Safe outputs (pull requests): https://github.github.com/gh-aw/reference/safe-outputs-pull-requests/
- Safe outputs spec: https://github.github.com/gh-aw/reference/safe-outputs-specification/
- Safe outputs staged mode: https://github.github.com/gh-aw/reference/staged-mode/
- Sandbox: https://github.github.com/gh-aw/reference/sandbox/
- Templating: https://github.github.com/gh-aw/reference/templating/
- Threat detection: https://github.github.com/gh-aw/reference/threat-detection/
- Tools: https://github.github.com/gh-aw/reference/tools/
- Triggering CI: https://github.github.com/gh-aw/reference/triggering-ci/
- Triggers: https://github.github.com/gh-aw/reference/triggers/
- Editors: https://github.github.com/gh-aw/reference/editors/

### Troubleshooting Surface

- Debugging workflows: https://github.github.com/gh-aw/troubleshooting/debugging/
- Debugging GHE Cloud with data residency: https://github.github.com/gh-aw/troubleshooting/debug-ghe/
- Agent factory: https://github.github.com/gh-aw/agent-factory-status/

## Raw Prompt Entry Points

- Create/debug router: https://raw.githubusercontent.com/github/gh-aw/main/create.md
- Standalone debug prompt: https://raw.githubusercontent.com/github/gh-aw/main/debug.md
- Canonical reference prompt: https://raw.githubusercontent.com/github/gh-aw/main/.github/aw/github-agentic-workflows.md

## Task-Specific Raw Prompts

- Update existing workflow: https://raw.githubusercontent.com/github/gh-aw/main/.github/aw/update-agentic-workflow.md
- Debug workflow: https://raw.githubusercontent.com/github/gh-aw/main/.github/aw/debug-agentic-workflow.md
- Upgrade workflows: https://raw.githubusercontent.com/github/gh-aw/main/.github/aw/upgrade-agentic-workflows.md

## Core Command Surface

- `gh aw compile`
- `gh aw validate`
- `gh aw fix --write`
- `gh aw update`
- `gh aw upgrade`
- `gh aw logs --json`
- `gh aw audit <run-id> --json`
- `gh aw mcp inspect`
- `gh aw health`

## Debugging Priorities

- Audit a concrete run before speculating.
- Compare requested tool names with configured tool and safe-output names.
- Check network denials and ecosystem mismatches before adding broad allowlists.
- If the workflow resembles a factory workflow, compare against that upstream source before inventing a new fix path.
- Prefer `agentic-workflows` MCP tool equivalents when `gh aw` CLI auth is unavailable.