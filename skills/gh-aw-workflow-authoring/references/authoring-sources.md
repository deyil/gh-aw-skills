# GH-AW Authoring Sources

**Do not read every link; start with "Read first" and expand only when the task requires it.**

Use these sources in roughly this order when creating or substantially redesigning workflows.

## Read First

- Full docs: https://github.github.com/gh-aw/llms-full.txt
- Agent Factory status index: https://github.github.com/gh-aw/agent-factory-status/
- Agent Factory workflow source tree: https://github.com/github/gh-aw/tree/main/.github/workflows
- Creating workflows guide: https://github.github.com/gh-aw/setup/creating-workflows/
- CLI commands: https://github.github.com/gh-aw/setup/cli/
- Workflow structure: https://github.github.com/gh-aw/reference/workflow-structure/
- Frontmatter reference: https://github.github.com/gh-aw/reference/frontmatter/
- Tools reference: https://github.github.com/gh-aw/reference/tools/
- Reusing workflows/imports: https://github.github.com/gh-aw/guides/packaging-imports/
- Security architecture: https://github.github.com/gh-aw/introduction/architecture/

## Use When Needed

- Agentic authoring guide: https://github.github.com/gh-aw/guides/agentic-authoring/
- GitHub read tools: https://github.github.com/gh-aw/reference/github-tools/
- Network access: https://github.github.com/gh-aw/reference/network/
- Imports reference: https://github.github.com/gh-aw/reference/imports/
- Compilation process: https://github.github.com/gh-aw/reference/compilation-process/
- Safe outputs reference: https://github.github.com/gh-aw/reference/safe-outputs/

## Raw Prompts

- Create entry point: https://raw.githubusercontent.com/github/gh-aw/main/create.md
- Install entry point: https://raw.githubusercontent.com/github/gh-aw/main/install.md
- Create new workflow: https://raw.githubusercontent.com/github/gh-aw/main/.github/aw/create-agentic-workflow.md
- Create shared component: https://raw.githubusercontent.com/github/gh-aw/main/.github/aw/create-shared-agentic-workflow.md

## Discovery Fallback

- llms index: https://github.github.com/gh-aw/llms.txt
- Sitemap index: https://github.github.com/gh-aw/sitemap-index.xml

## Practical Authoring Notes

- New workflows live in `.github/workflows/<workflow-id>.md` and compile to `.github/workflows/<workflow-id>.lock.yml`.
- Markdown body edits can be shipped without recompilation; frontmatter edits require `gh aw compile`.
- `gh aw new` can scaffold a template, but upstream prompt-driven authoring is the more authoritative source for design guidance.
- The Agent Factory status page is a ready-to-use index: each workflow row links to a concrete `.github/workflows/*.md` source file you can inspect and adapt.
- Favor `tools.github.toolsets` for GitHub reads and `safe-outputs` for writes.
- Use sitemap-driven discovery if the docs navigation changes or a page moves.
