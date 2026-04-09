# GH-AW Maintenance Sources

Use these sources when editing, debugging, fixing, or upgrading existing gh-aw workflows.

## Machine-Readable Discovery

- llms index: https://github.github.com/gh-aw/llms.txt
- Full docs: https://github.github.com/gh-aw/llms-full.txt
- Sitemap index: https://github.github.com/gh-aw/sitemap-index.xml
- Sitemap body: https://github.github.com/gh-aw/sitemap-0.xml

## Canonical Docs

- CLI commands: https://github.github.com/gh-aw/setup/cli/
- Debugging guide: https://github.github.com/gh-aw/troubleshooting/debugging/
- Common issues: https://github.github.com/gh-aw/troubleshooting/common-issues/
- Error reference: https://github.github.com/gh-aw/troubleshooting/errors/
- Workflow structure: https://github.github.com/gh-aw/reference/workflow-structure/
- Frontmatter reference: https://github.github.com/gh-aw/reference/frontmatter/
- Tools reference: https://github.github.com/gh-aw/reference/tools/
- Safe outputs reference: https://github.github.com/gh-aw/reference/safe-outputs/
- GH-AW as MCP server: https://github.github.com/gh-aw/reference/gh-aw-as-mcp-server/

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
- Prefer `agentic-workflows` MCP tool equivalents when `gh aw` CLI auth is unavailable.