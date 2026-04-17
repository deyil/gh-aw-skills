# GH-AW Maintenance Sources

**Do not read every link; start with "Read first" and expand only when the task requires it.**

Use these sources when editing, debugging, fixing, or upgrading existing gh-aw workflows.

## Read First

- Agent Factory status index: https://github.github.com/gh-aw/agent-factory-status/
- Agent Factory workflow source tree: https://github.com/github/gh-aw/tree/main/.github/workflows
- Debugging guide: https://github.github.com/gh-aw/troubleshooting/debugging/
- Common issues: https://github.github.com/gh-aw/troubleshooting/common-issues/
- Error reference: https://github.github.com/gh-aw/troubleshooting/errors/
- Workflow structure: https://github.github.com/gh-aw/reference/workflow-structure/
- Frontmatter reference: https://github.github.com/gh-aw/reference/frontmatter/
- Tools reference: https://github.github.com/gh-aw/reference/tools/
- Safe outputs reference: https://github.github.com/gh-aw/reference/safe-outputs/

## Use When Needed

- Compilation process: https://github.github.com/gh-aw/reference/compilation-process/
- Actionlint usage: https://github.com/rhysd/actionlint/blob/main/docs/usage.md
- Releases and versioning: https://github.github.com/gh-aw/reference/releases/
- GH-AW as MCP server: https://github.github.com/gh-aw/reference/gh-aw-as-mcp-server/
- Network access: https://github.github.com/gh-aw/reference/network/
- GitHub read tools: https://github.github.com/gh-aw/reference/github-tools/
- Staged mode: https://github.github.com/gh-aw/reference/staged-mode/
- Threat detection: https://github.github.com/gh-aw/reference/threat-detection/

## Discovery Fallback

- Full docs: https://github.github.com/gh-aw/llms-full.txt
- Sitemap index: https://github.github.com/gh-aw/sitemap-index.xml

## Raw Prompts

- Debug prompt: https://raw.githubusercontent.com/github/gh-aw/main/debug.md
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
