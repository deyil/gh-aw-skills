# GH-AW Review Sources

**Do not read every link; start with "Read first" and expand only when the task requires it.**

Use these sources to ground review comments in actual gh-aw behavior.

## Read First

- Overview: https://github.github.com/gh-aw/introduction/overview/
- How they work: https://github.github.com/gh-aw/introduction/how-they-work/
- Security architecture: https://github.github.com/gh-aw/introduction/architecture/
- Agent Factory status index: https://github.github.com/gh-aw/agent-factory-status/
- Agent Factory workflow source tree: https://github.com/github/gh-aw/tree/main/.github/workflows
- Workflow structure: https://github.github.com/gh-aw/reference/workflow-structure/
- Frontmatter reference: https://github.github.com/gh-aw/reference/frontmatter/
- Tools reference: https://github.github.com/gh-aw/reference/tools/
- Safe outputs reference: https://github.github.com/gh-aw/reference/safe-outputs/

## Use When Needed

- Actionlint usage: https://github.com/rhysd/actionlint/blob/main/docs/usage.md
- GitHub tools reference: https://github.github.com/gh-aw/reference/github-tools/
- Network reference: https://github.github.com/gh-aw/reference/network/
- Imports reference: https://github.github.com/gh-aw/reference/imports/
- Debugging: https://github.github.com/gh-aw/troubleshooting/debugging/
- Staged mode: https://github.github.com/gh-aw/reference/staged-mode/
- Threat detection: https://github.github.com/gh-aw/reference/threat-detection/
- GH-AW as MCP server: https://github.github.com/gh-aw/reference/gh-aw-as-mcp-server/

## Discovery Fallback

- Full docs: https://github.github.com/gh-aw/llms-full.txt
- Sitemap index: https://github.github.com/gh-aw/sitemap-index.xml

## Review Heuristics

- Check whether the proposal is actually compatible with gh-aw's staged execution model and supported orchestration patterns.
- Prefer explicit gh-aw references over generic GitHub Actions intuition.
- When a ready-to-use factory workflow exists for the same job, review whether the bespoke design is materially better or just more complex.
- Use the sitemap and llms endpoints when you suspect the docs have moved or a newer page exists.
