# gh-aw-skills: Agent skills for GitHub Agentic Workflows

<div align="center">

[![Skills](https://img.shields.io/badge/skills-3-blue)](skills/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub release](https://img.shields.io/github/v/release/deyil/gh-aw-skills)](https://github.com/deyil/gh-aw-skills/releases)

</div>

Three GitHub Copilot agent skills that give your AI assistant deep expertise in authoring, reviewing, and maintaining [GitHub Agentic Workflows](https://github.github.com/gh-aw/).

<div align="center">
<h3>Quick Install</h3>

```bash
npx skills add https://github.com/deyil/gh-aw-skills
```

**Or install individual skills:**

```bash
npx skills add https://github.com/deyil/gh-aw-skills --skill gh-aw-workflow-authoring
npx skills add https://github.com/deyil/gh-aw-skills --skill gh-aw-workflow-review
npx skills add https://github.com/deyil/gh-aw-skills --skill gh-aw-workflow-maintenance
```

</div>

---

## What Are gh-aw-skills?

**The Problem**: GitHub Agentic Workflows (gh-aw) have their own frontmatter schema, single-job execution model, safe-outputs write pattern, and Peli's Agent Factory catalog. Without purpose-built guidance, AI assistants fall back on generic GitHub Actions assumptions — and produce workflows that validate poorly, have unsafe write patterns, or re-invent workflows that already exist in the factory.

**The Solution**: Three installable Copilot skills that load gh-aw expertise on demand. Each skill routes to current live docs via `llms.txt`, checks Peli's Agent Factory before designing bespoke workflows, and enforces the correct compile, security, and tool patterns for each task type.

### Why Use gh-aw-skills?

| Feature | What It Does |
|---------|--------------|
| **Factory-First Routing** | Checks Peli's Agent Factory before authoring from scratch — reuses proven workflows when they fit |
| **Authoring Skill** | Scaffolds new workflows with the right trigger, engine, toolsets, safe outputs, and minimal frontmatter |
| **Review Skill** | Audits for architectural fit, security guardrails, single-job model violations, and operability gaps |
| **Maintenance Skill** | Edits and upgrades existing workflows with compile-aware, surgical changes and a structured debug flow |
| **Live Docs References** | Each skill consults `llms.txt` and `llms-full.txt` for current gh-aw semantics rather than stale training data |
| **Security by Default** | Enforces read-only agent jobs, `safe-outputs:` write routing, and explicit `network:` constraints |

---

## Quick Example

```bash
# Install the skills pack
npx skills add https://github.com/deyil/gh-aw-skills

# Copilot now activates the right skill automatically based on your request.

# === AUTHORING ===
# "Create a workflow that triages new issues and posts a summary comment"
# → gh-aw-workflow-authoring checks Peli's Agent Factory, finds the triage
#   pattern, scaffolds .github/workflows/triage-issues.md with safe outputs,
#   and compiles the lock file.

# === REVIEW ===
# "Review .github/workflows/triage-issues.md for security and architectural fit"
# → gh-aw-workflow-review audits the workflow across six lenses: architectural
#   fit, setup correctness, security guardrails, authoring correctness,
#   operability, and maintainability.

# === MAINTENANCE ===
# "The triage-issues run is failing – here's the run URL"
# → gh-aw-workflow-maintenance audits the run with gh aw audit, traces
#   the failure to a missing tool or secret, applies a surgical fix,
#   and recompiles only if frontmatter changed.

# === UPGRADE ===
# "Upgrade all gh-aw workflows in this repo to current patterns"
# → gh-aw-workflow-maintenance compares each workflow against the nearest
#   upstream factory baseline and applies the smallest conforming edits.
```

---

## Design Philosophy

1. **Skills over prompts** — Each skill encodes domain knowledge as structured instructions with source references, not as one-shot prompts. The agent loads the skill at task time and grounds its answers in current docs.

2. **Factory-first, bespoke second** — Before designing anything new, the authoring and maintenance skills route to Peli's Agent Factory. Reusing a proven upstream workflow is faster and safer than reinventing it.

3. **Task-type separation** — Authoring, review, and maintenance are distinct skills with distinct rules. This prevents review heuristics from contaminating active edits, and maintenance patterns from leaking into fresh designs.

4. **Surgical edits, not rewrites** — The maintenance skill enforces the smallest change that satisfies the task. Frontmatter and body edits are classified separately; only frontmatter changes trigger recompilation.

5. **Security by construction** — All three skills enforce read-only agent jobs, `safe-outputs:` for writes, and explicit network constraints. These are not optional review findings — they are design requirements baked into every skill.

---

## Skills Included

### `gh-aw-workflow-authoring`

Activate when creating new workflows, scaffolding shared components, or making deliberate authoring changes.

**Routing logic:**
- Exact factory match → reuse upstream `.md` source, adapt minimally
- Partial factory match → borrow nearest pattern, adapt for repository constraints
- No factory match → use upstream `create.md` prompt flow for bespoke design

**Enforces:** minimal frontmatter, correct engine/secret pairing, `safe-outputs:` for all GitHub writes, `tools.github.toolsets` for reads, single-job model constraints.

### `gh-aw-workflow-review`

Activate for design reviews, security audits, correctness checks, or pre-merge workflow review.

**Six review lenses:**
| Lens | What It Checks |
|------|----------------|
| Architectural Fit | Single-job model compatibility, pipeline vs. gh-aw scope |
| Setup Correctness | Bootstrap artifacts, engine/secret alignment, source+lock pairs |
| Security & Guardrails | Read-only agent job, `safe-outputs:`, network scope, untrusted input handling |
| Authoring Correctness | Frontmatter validity, toolset usage, import cleanliness |
| Operability | Compilability, `noop` handling, schedule hygiene, debug path |
| Maintainability | Defaults noise, prompt conciseness, frontmatter churn risk |

### `gh-aw-workflow-maintenance`

Activate when editing, fixing, debugging, or upgrading existing workflows.

**Work classification:**
- Prompt-only change → edit body, skip recompilation
- Frontmatter change → edit YAML, compile, fix all validation errors
- Run failure → audit run first, trace failure, apply surgical fix
- Bulk upgrade → compare against factory baseline, borrow smallest conforming patterns

---

## How gh-aw-skills Compares

| Capability | gh-aw-skills | Generic Copilot | GitHub Actions docs |
|------------|-------------|-----------------|---------------------|
| gh-aw frontmatter schema | ✅ Correct | ⚠️ Guesses | ❌ Not covered |
| Peli's Agent Factory routing | ✅ Built-in | ❌ None | ❌ Not covered |
| safe-outputs enforcement | ✅ Always checked | ❌ Often missed | ⚠️ Mentioned |
| Live docs grounding (`llms.txt`) | ✅ Per skill | ❌ Training data only | ✅ Web search needed |
| Task-type separation (author/review/maintain) | ✅ Separate skills | ❌ One generic agent | ❌ Not applicable |
| Compile-aware edit classification | ✅ Enforced | ❌ Not aware | ❌ Not applicable |
| Debug flow for failing runs | ✅ Structured | ⚠️ Ad hoc | ❌ Manual only |

**When gh-aw-skills is most useful:**
- You're building or maintaining gh-aw workflows with GitHub Copilot
- You want factory-first routing to avoid reinventing proven patterns
- You need security guardrail enforcement baked into every AI suggestion

**When gh-aw-skills may not apply:**
- Your workflows are traditional GitHub Actions (not gh-aw)
- You're not using GitHub Copilot or a compatible skill-loading agent

---

## Installation

### Install All Skills (Recommended)

```bash
npx skills add https://github.com/deyil/gh-aw-skills
```

This installs all three skills and pins them in `skills-lock.json`.

### Install Individual Skills

```bash
# Only the authoring skill
npx skills add https://github.com/deyil/gh-aw-skills --skill gh-aw-workflow-authoring

# Only the review skill
npx skills add https://github.com/deyil/gh-aw-skills --skill gh-aw-workflow-review

# Only the maintenance skill
npx skills add https://github.com/deyil/gh-aw-skills --skill gh-aw-workflow-maintenance
```

### Verify Installation

```bash
# List installed skills
npx skills list

# Output includes entries like:
# gh-aw-workflow-authoring  github:deyil/gh-aw-skills
# gh-aw-workflow-review     github:deyil/gh-aw-skills
# gh-aw-workflow-maintenance github:deyil/gh-aw-skills
```

### Prerequisites

- Node.js 18+ (for `npx skills`)
- GitHub Copilot with agent mode enabled in VS Code
- A repository with gh-aw initialized (`gh aw init` or the upstream `install.md` flow)

---

## Quick Start

1. **Install the skills pack:**

   ```bash
   npx skills add https://github.com/deyil/gh-aw-skills
   ```

2. **Open GitHub Copilot in agent mode** in your repository.

3. **Make a request.** Copilot will activate the matching skill automatically:

   | Request type | Skill activated |
   |---|---|
   | "Create a new workflow that…" | `gh-aw-workflow-authoring` |
   | "Review this workflow for…" | `gh-aw-workflow-review` |
   | "Fix / update / debug this workflow…" | `gh-aw-workflow-maintenance` |

4. **Follow the skill's guided output.** Each skill references current gh-aw docs, checks Peli's Agent Factory, and applies task-appropriate rules before producing recommendations or changes.

---

## Architecture

```
┌────────────────────────────────────────────────────────────────────┐
│                        User Request                                │
│  "Create / Review / Fix a gh-aw workflow"                          │
└────────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌────────────────────────────────────────────────────────────────────┐
│                   GitHub Copilot (agent mode)                      │
│   Reads skills-lock.json → loads matching SKILL.md                 │
└────────────────────────────────────────────────────────────────────┘
                               │
          ┌────────────────────┼────────────────────┐
          ▼                    ▼                    ▼
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│  gh-aw-workflow │  │  gh-aw-workflow │  │  gh-aw-workflow │
│   -authoring    │  │    -review      │  │  -maintenance   │
│                 │  │                 │  │                 │
│ references/     │  │ references/     │  │ references/     │
│ authoring-      │  │ review-         │  │ maintenance-    │
│ sources.md      │  │ sources.md      │  │ sources.md      │
└────────┬────────┘  └────────┬────────┘  └────────┬────────┘
         │                    │                    │
         └────────────────────┼────────────────────┘
                              ▼
┌───────────────────────────────────────────────────────────────────┐
│                    External Sources                               │
│  ┌──────────────────────┐   ┌──────────────────────────────────┐  │
│  │  Peli's Agent Factory│   │  gh-aw live docs (llms.txt)      │  │
│  │  github.com/github/  │   │  github.github.com/gh-aw/        │  │
│  │  gh-aw/workflows     │   │  llms.txt · llms-full.txt        │  │
│  └──────────────────────┘   └──────────────────────────────────┘  │
└───────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌───────────────────────────────────────────────────────────────────┐
│                    Repository Output                              │
│  .github/workflows/<name>.md   ←  workflow source (markdown)      │
│  .github/workflows/<name>.lock.yml  ←  compiled lock file         │
└───────────────────────────────────────────────────────────────────┘
```

---

## Troubleshooting

### Skill isn't activating for my request

Copilot selects skills based on description match. Be explicit in your phrasing:

```
# Too vague:
"Help with my workflow"

# Gets the right skill:
"Create a new gh-aw workflow that..."
"Review this gh-aw workflow for security..."
"Fix the failing gh-aw run for..."
```

### `npx skills add` fails with a resolution error

```bash
# Check your Node version (18+ required)
node --version

# Try with the full HTTPS URL
npx skills add https://github.com/deyil/gh-aw-skills

# Or specify the skill directly
npx skills add https://github.com/deyil/gh-aw-skills --skill gh-aw-workflow-authoring
```

### Copilot suggests direct write permissions instead of `safe-outputs:`

This often means the authoring or maintenance skill didn't load. Other causes include model drift or incomplete context injection. Confirm the skill is installed:

```bash
npx skills list | grep gh-aw
```

If missing, reinstall and reload your editor.

### Skill references docs that return 404

The `references/*.md` files link to `github.github.com/gh-aw/`. If these return 404, the gh-aw docs site may have moved. Check the live index at:

```
https://github.github.com/gh-aw/llms.txt
```

### Recompilation errors after frontmatter edit

Run strict validation to see all errors before stopping:

```bash
gh aw compile --strict .github/workflows/<name>.md
gh aw validate .github/workflows/<name>.md
```

Fix all reported errors; do not commit a lock file that failed validation.

---

## Limitations

### What gh-aw-skills Doesn't Do

- **Doesn't install or configure the `gh-aw` CLI** — You must have `gh aw` set up separately before the skills are useful. See the [gh-aw quick start](https://github.github.com/gh-aw/setup/quick-start/).
- **Doesn't cover traditional GitHub Actions** — These skills are scoped to gh-aw (markdown-source workflows compiled to lock files). For standard `.yml` Actions workflows, use generic Copilot or GitHub Actions docs.
- **Doesn't execute workflows** — Skills guide authoring, review, and maintenance; they don't trigger or monitor live runs.
- **Doesn't provide a UI** — Skills load into Copilot's agent context; there is no standalone web or desktop interface.

### Known Constraints

| Capability | Current State | Notes |
|------------|---------------|-------|
| Multi-agent / fan-out workflows | ✅ Supported | Use `call-workflow` (compile-time fan-out) or `dispatch-workflow` (trigger up to 3 downstream workflows) |
| Cross-job state passing | ✅ Supported | `workflow_call` safe-outputs expose values (e.g. `created_pr_number`) to calling workflows |
| Cross-repo dispatch | ⚠️ Experimental | `dispatch_repository` output is experimental; see gh-aw safe-outputs docs |
| Rollback orchestration | ⚠️ Hybrid | Design rollback logic in a called workflow; not natively modeled in a single gh-aw source file |
| Auto-updating references | ⚠️ Manual | References are pinned in `*.md` files; update when gh-aw docs move |

---

## FAQ

### What is a "skill" in this context?

A skill is a Markdown file with YAML frontmatter and structured instructions that GitHub Copilot loads at task time. When your request matches a skill's description, Copilot incorporates the skill's rules and source references into its response. Skills are installed via `npx skills add` and tracked in `skills-lock.json`.

### Do I need all three skills or just one?

Install all three for the best experience — Copilot routes between them automatically based on what you're asking. If you only ever do reviews, installing only `gh-aw-workflow-review` is sufficient.

### What is Peli's Agent Factory?

[Peli's Agent Factory](https://github.github.com/gh-aw/blog/2026-01-12-welcome-to-pelis-agent-factory/) is the upstream catalog of ready-to-use gh-aw workflows maintained by the gh-aw team. Each skill in this pack checks the factory index before designing bespoke workflows, so you benefit from proven patterns rather than starting from scratch.

### Does this work outside VS Code?

The skills use the `npx skills` format, which is compatible with any agent that supports the skills specification. VS Code with GitHub Copilot agent mode is the primary tested environment.

### How do I update the skills to the latest version?

```bash
npx skills update https://github.com/deyil/gh-aw-skills
```

### What engine does gh-aw use?

gh-aw supports Copilot (default), Claude, Codex, and Gemini. Configure the `engine:` field in your workflow's YAML frontmatter and ensure the matching secret is set:

| Engine | Required secret |
|--------|----------------|
| Copilot | `COPILOT_GITHUB_TOKEN` |
| Claude | `ANTHROPIC_API_KEY` |
| Codex | `OPENAI_API_KEY` |
| Gemini | `GEMINI_API_KEY` |

### How do I add a new skill to this repo?

1. Create `skills/<skill-name>/SKILL.md` with YAML frontmatter (`name:`, `description:`) and your skill body.
2. Optionally add `skills/<skill-name>/references/` for source link files.
3. Open a pull request — the skill becomes installable automatically on merge.

---

## Contributing

Pull requests for new gh-aw skills, improved references, or corrected source links are welcome. Please:

- Follow the existing `SKILL.md` structure: YAML frontmatter with `name` + `description`, then a Markdown body.
- Keep `references/*.md` up to date with canonical gh-aw doc URLs.
- One skill per pull request.

---

## License

MIT — see [LICENSE](LICENSE).
