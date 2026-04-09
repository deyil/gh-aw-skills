---
name: gh-aw-workflow-review
description: "Review Github Agentic Workflows (gh-aw) and shared components for architectural fit, security guardrails, correctness, and operational quality before or after changes land."
---

# GH-AW Workflow Review

Use this skill when the user wants a design review, security review, correctness review, or code review of Github Agentic Workflows, imports, prompts, or shared components.

## Start Here

Before reviewing, consult `references/review-sources.md` so findings are based on current gh-aw semantics rather than generic GitHub Actions assumptions.

## Review Lens

Review workflows against these categories.

### 1. Architectural Fit

- Does the requested behavior fit gh-aw's single-job model?
- Is the design trying to wait on external events, coordinate multi-stage pipelines, or move state between jobs in a way gh-aw does not support?
- Should the solution be split into simpler gh-aw units or moved to traditional GitHub Actions?

### 2. Security And Guardrails

- Is the agent job read-only?
- Are write operations routed through `safe-outputs:` instead of direct write permissions?
- Is `network:` explicit and minimal?
- Are ecosystem identifiers used where appropriate instead of ad hoc package-registry domains?
- Is untrusted user content treated as untrusted, and is sanitized context used where appropriate?
- Are risky features like auto-merge or unsafe credential patterns being proposed?

### 3. Authoring Correctness

- Are the source `.md` and compiled `.lock.yml` treated as a pair?
- Is the workflow structure valid for gh-aw frontmatter and markdown semantics?
- Are GitHub reads modeled with `tools.github.toolsets` rather than mutation tools or direct API assumptions?
- Are MCP servers configured appropriately, with read-only allowlists where possible?
- Are shared components scoped narrowly and imported cleanly?

### 4. Operability

- Can the workflow be compiled and validated cleanly?
- If it depends on `agentic-workflows:` introspection tools, does it have `actions: read`?
- Does the prompt tell the agent what to do when no action is needed, typically via `noop`?
- Are schedules, rate limits, skip rules, or duplicate-prevention settings appropriate?
- Is there a realistic debugging path using `logs`, `audit`, `mcp inspect`, or `health`?

### 5. Maintainability

- Are defaults omitted instead of restated noisily?
- Is the prompt concise, explicit, and testable?
- Are updates likely to require frontmatter churn when a body-only edit would suffice?
- Are imports, labels, and metadata serving a real purpose?

## Evidence To Use

- The current `.md` workflow file and corresponding `.lock.yml`.
- `gh aw compile --strict` or `gh aw validate` results when available.
- `gh aw audit` and `gh aw logs` output for behavior-based findings.
- `gh aw mcp inspect` output for MCP and tool configuration findings.
- The authoritative docs pages listed in the references file.

## Review Output

1. Lead with findings, ordered by severity.
2. For each finding, explain the concrete risk or behavioral failure.
3. Point to the exact workflow area or configuration pattern that causes it.
4. Suggest the smallest credible fix.
5. If there are no findings, say so explicitly and mention residual testing or validation gaps.

## High-Signal Red Flags

- Direct write permissions on the agent job.
- Broad or implicit network access.
- Use of unsupported orchestration patterns.
- Missing `actions: read` for workflow-introspection tooling.
- GitHub mutation operations modeled as tools instead of safe outputs.
- Prompt instructions that omit safe no-op behavior for successful no-action runs.
- Large, needless frontmatter rewrites that increase upgrade risk.