# GH-AW Authoring Sources

Use these sources in roughly this order when creating or substantially redesigning workflows.

## Machine-Readable Discovery

- Docs index: https://github.github.com/gh-aw/
- llms index: https://github.github.com/gh-aw/llms.txt
- Compact docs: https://github.github.com/gh-aw/llms-small.txt
- Full docs: https://github.github.com/gh-aw/llms-full.txt
- Workflow pattern set: https://github.github.com/gh-aw/_llms-txt/agentic-workflows.txt
- Sitemap index: https://github.github.com/gh-aw/sitemap-index.xml
- Sitemap body: https://github.github.com/gh-aw/sitemap-0.xml

## Canonical Upstream Sources

- Repository: https://github.com/github/gh-aw
- Overview: https://github.github.com/gh-aw/introduction/overview/
- Creating workflows guide: https://github.github.com/gh-aw/setup/creating-workflows/
- CLI commands: https://github.github.com/gh-aw/setup/cli/
- Workflow structure: https://github.github.com/gh-aw/reference/workflow-structure/
- Frontmatter reference: https://github.github.com/gh-aw/reference/frontmatter/
- Tools reference: https://github.github.com/gh-aw/reference/tools/
- Agentic authoring guide: https://github.github.com/gh-aw/guides/agentic-authoring/
- Reusing workflows/imports: https://github.github.com/gh-aw/guides/packaging-imports/
- Security architecture: https://github.github.com/gh-aw/introduction/architecture/

## Raw Prompt Entry Points

- Create entry point: https://raw.githubusercontent.com/github/gh-aw/main/create.md
- Install entry point: https://raw.githubusercontent.com/github/gh-aw/main/install.md
- Canonical reference prompt: https://raw.githubusercontent.com/github/gh-aw/main/.github/aw/github-agentic-workflows.md

## Task-Specific Raw Prompts

- Create new workflow: https://raw.githubusercontent.com/github/gh-aw/main/.github/aw/create-agentic-workflow.md
- Create shared component: https://raw.githubusercontent.com/github/gh-aw/main/.github/aw/create-shared-agentic-workflow.md
- Update existing workflow: https://raw.githubusercontent.com/github/gh-aw/main/.github/aw/update-agentic-workflow.md

## Practical Authoring Notes

- New workflows live in `.github/workflows/<workflow-id>.md` and compile to `.github/workflows/<workflow-id>.lock.yml`.
- Markdown body edits can be shipped without recompilation; frontmatter edits require `gh aw compile`.
- `gh aw new` can scaffold a template, but upstream prompt-driven authoring is the more authoritative source for design guidance.
- Favor `tools.github.toolsets` for GitHub reads and `safe-outputs` for writes.
- Use sitemap-driven discovery if the docs navigation changes or a page moves.