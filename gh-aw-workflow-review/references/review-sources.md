# GH-AW Review Sources

Use these sources to ground review comments in actual gh-aw behavior.

## Machine-Readable Discovery

- llms index: https://github.github.com/gh-aw/llms.txt
- Full docs: https://github.github.com/gh-aw/llms-full.txt
- Sitemap index: https://github.github.com/gh-aw/sitemap-index.xml
- Sitemap body: https://github.github.com/gh-aw/sitemap-0.xml

## Core Review Sources

- Overview: https://github.github.com/gh-aw/introduction/overview/
- Security architecture: https://github.github.com/gh-aw/introduction/architecture/
- Workflow structure: https://github.github.com/gh-aw/reference/workflow-structure/
- Frontmatter reference: https://github.github.com/gh-aw/reference/frontmatter/
- Tools reference: https://github.github.com/gh-aw/reference/tools/
- Safe outputs reference: https://github.github.com/gh-aw/reference/safe-outputs/
- GitHub tools reference: https://github.github.com/gh-aw/reference/github-tools/
- Network reference: https://github.github.com/gh-aw/reference/network/
- Imports reference: https://github.github.com/gh-aw/reference/imports/
- Troubleshooting/debugging: https://github.github.com/gh-aw/troubleshooting/debugging/

## Pattern Sources

- Agentic authoring: https://github.github.com/gh-aw/guides/agentic-authoring/
- Reusing workflows: https://github.github.com/gh-aw/guides/packaging-imports/
- MCPs guide: https://github.github.com/gh-aw/guides/mcps/
- IssueOps: https://github.github.com/gh-aw/patterns/issue-ops/
- LabelOps: https://github.github.com/gh-aw/patterns/label-ops/
- Monitoring: https://github.github.com/gh-aw/patterns/monitoring/
- MultiRepoOps: https://github.github.com/gh-aw/patterns/multi-repo-ops/
- WorkQueueOps: https://github.github.com/gh-aw/patterns/workqueue-ops/
- BatchOps: https://github.github.com/gh-aw/patterns/batch-ops/

## Raw Canonical References

- Canonical reference prompt: https://raw.githubusercontent.com/github/gh-aw/main/.github/aw/github-agentic-workflows.md
- Create prompt router: https://raw.githubusercontent.com/github/gh-aw/main/create.md
- Debug prompt router: https://raw.githubusercontent.com/github/gh-aw/main/debug.md

## Review Heuristics

- Check whether the proposal is actually compatible with single-job agent execution.
- Prefer explicit gh-aw references over generic GitHub Actions intuition.
- Use the sitemap and llms endpoints when you suspect the docs have moved or a newer page exists.