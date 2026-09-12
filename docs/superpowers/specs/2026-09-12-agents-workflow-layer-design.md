# `.agents/` Orchestration Layer — Design Spec

**Date**: 2026-09-12
**Status**: Approved (Brainstorming Design Spec)
**Authors**: Claude Opus 5 & DanhDue ExOICTIF
**Scope**: Agent customization layer (`.agents/`) across two runtimes — Antigravity and Claude Code

---

## Status

Approved. Phase 1 (this spec) is implementation-ready. Phase 2 (Claude Code skill wiring + superpowers fork) is deferred — see Non-Goals.

---

## Background

### The governing fact: `.agents/` is Antigravity's native convention

This was established by extracting the shipped Antigravity Customization System guide from
`/Applications/Antigravity.app/Contents/Resources/bin/language_server`. It is not a house
convention this repo invented — it is the format Antigravity discovers automatically.

**Customization types (there are exactly five, and `workflows/` is not one of them):**

| Type | Location | Scope | Purpose (Antigravity's own wording) |
|---|---|---|---|
| **Rules** | `rules/*.md`, or standalone `AGENTS.md` / `GEMINI.md` | Contextual / Hierarchical | "Enforcing coding styles, API restrictions, and local guidelines" |
| **Skills** | `skills/<name>/SKILL.md` | On-Demand (Progressive) | "Teaching the agent multi-step procedures, **runbooks**, and **tool workflows**" |
| **Plugins** | `plugins/<name>/plugin.json` | Bundle | "Packaging related skills, rules, and MCP configs into a single unit" |
| **Hooks** | `hooks.json` | Lifecycle Event | Scripts at agent lifecycle points |
| **MCP Servers** | `mcp_config.json` | Tool Integration | External service/tool providers |

**Discovery locations**, in Antigravity's priority order (highest first):

1. **Workspace Project** — `.agents/` (or `.agent/`, `_agents/`, `_agent/`) at repo root; walks up from CWD to the repo root.
2. **Declared Configurations** — `skills.json` / `plugins.json` in the workspace.
3. **Global Discovery** — `~/.gemini/config/`.
4. **Built-in Customizations** — default skills bundled with the app.
5. **Global Declared Configurations**.

Two consequences matter enormously here:

- **Workspace beats built-in.** "If there are naming conflicts (e.g., two skills with the same name), the higher-priority customization overrides the lower-priority one." So a forked skill in `.agents/skills/` *wins* in Antigravity.
- **Progressive disclosure.** Skills are not loaded by default — only name and description are injected, and the body is read on activation. For rules, "only `always_on` rules are loaded unconditionally"; `trigger: model_decision` rules behave like skills. Rules are deduplicated **by resolved file path**.

**Skill authoring contract**: `SKILL.md` with YAML frontmatter requiring exactly `name`
(lowercase, hyphenated) and `description` (third person, states *what* and *when* — this is
the field the agent reads to decide activation). Optional subdirectories: `scripts/`,
`examples/`, `resources/`, `references/`.

### What this means for the audit

The repo is used from **two runtimes**, and almost every defect is a runtime-visibility
mismatch rather than a content defect:

| Asset | Antigravity | Claude Code |
|---|---|---|
| `.agents/rules/*.md` | ✅ native, `always_on` honoured | ❌ not a load path |
| `.agents/skills/*/SKILL.md` | ✅ native, workspace priority | ❌ not a load path (no `.claude/`) |
| `.agents/config.json` | ❌ not a recognised file | ❌ not a recognised file |
| `.agents/workflows/` | ❌ not a customization type | ❌ not a load path |
| root `AGENTS.md` | ✅ native rule | ❌ (reads `CLAUDE.md`) |
| root `CLAUDE.md` | ❌ | ✅ native |

### Findings

**F1 — The declared Workflows tier can never work.**
`.agents/config.json` declares `"workflows_directory": ".agents/workflows"`. The directory
has never existed, `config.json` is read by no runtime, and `workflows/` is not an Antigravity
customization type. Creating it as planned would have produced a third orphan.

**F2 — The Epic pipeline is severed in Claude Code only.**
`.agents/skills/brainstorming/SKILL.md` was substantially rewritten against upstream (207
lines vs the plugin's 250; 97 added, 140 removed) to add *"Routing After Approval"* handing
epic-scale specs to `epic-designer`.

In Antigravity this works — workspace skills outrank built-ins. In Claude Code it does not
exist: the harness loads the plugin skill `superpowers:brainstorming`, which contains **zero**
references to `epic-designer` and states at its line 231: *"Do NOT invoke any other skill.
writing-plans is the next step."* Under Claude Code, brainstorming therefore always routes to
`writing-plans` and the Epic Lifecycle only advances by manual intervention.

**F3 — Orchestration is split-brain across three skills, and drops a gate.**
Each epic skill carries a partial lifecycle diagram; reassembled they disagree:

| Source | Gates it knows |
|---|---|
| `brainstorming` diagram | Gate 1 (Spec Approved), Gate 2 (HLD & Tasks), **Gate 4** (quality_check LGTM) |
| `epic-designer` | unnumbered "Confirm Task Breakdown" checkpoint |
| `epic-implementation` | unnumbered "user confirms execution order" checkpoint (SKILL.md:91) |

`brainstorming` jumps Gate 2 → Gate 4. **Gate 3 is defined nowhere**, and the missing Gate 3
is exactly `epic-implementation`'s execution-order checkpoint. No artefact owns the sequence,
so the sequence has a hole. This is runtime-independent — it is wrong in both.

**F4 — Two skills branch on a file that does not exist.**
`brainstorming` (lines 154–156) and `epic-designer` (line 244) read `.agents/config.yml` for
`auto_commit`. **`.agents/config.yml` does not exist.** One system, two formats, one of them
phantom.

**F5 — `rules/CLAUDE.md` is unregistered, and invisible to Claude Code.**
`.agents/rules/CLAUDE.md` (80 lines, `trigger: always_on`) is absent from `config.json`'s
`rules` array. `trigger: always_on` **is** valid Antigravity frontmatter and the file **is**
loaded unconditionally there. Claude Code never sees it: it auto-loads `CLAUDE.md` from the
**repo root** (plus nested files contextually), and this repo has no root `CLAUDE.md` —
`.agents/rules/CLAUDE.md` is the only one in the tree. Empirically confirmed: during the
session that produced this spec, none of its content appeared in the Claude Code context at
session start.

**F6 — Doc rot at the entry point.**
`AI_AGENT_README.md` points at six targets; **all six are missing**: `.agents/JULES_GUIDE.md`,
`.agents/README.md`, `.agents/patterns/`, `.agents/workflows/secrets-env.md`,
`.agents/rules/critical-rules.md` (wrong case), and skills `@api_integration` /
`@create_new_feature` (actual: `android-api-integration`). It embeds an absolute path from a
different machine: `file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/`.
`.cursorrules` documents `.agents/patterns/`, `.agents/templates/`, `.agents/checklists/`,
`.agents/contexts/project_state.md` and `.agents/workflows/` — none exist — and names skills
`@api_integration` / `critical-rules.md` that do not. `brainstorming` links
`docs/architecture/EPIC_LIFECYCLE.md` — missing.

**F7 (recorded, deferred) — 13 of 28 skills are byte-identical upstream copies.**
Diffed against `superpowers@6.3.0`: `dispatching-parallel-agents`, `executing-plans`,
`finishing-a-development-branch`, `receiving-code-review`, `requesting-code-review`,
`subagent-driven-development`, `systematic-debugging`, `test-driven-development`,
`using-git-worktrees`, `using-superpowers`, `verification-before-completion`, `writing-plans`,
`writing-skills`. Only `brainstorming` has diverged. **39** `superpowers:*` cross-references
inside `.agents/` would need rewriting to fork cleanly (11 of them in `epic-implementation`).
In Antigravity these copies are the live ones; in Claude Code the plugin's are. Phase 2.

---

## Goals

1. Give the epic sequence exactly one owner, with four complete, correctly-numbered gates (F3).
2. Place that owner where **both** runtimes can load it — as a Skill, the type Antigravity
   defines as being for "runbooks and tool workflows" (F1).
3. Make the existing rules load in Claude Code too, without duplicating their content (F5).
4. Collapse configuration to one file, so no skill branches on a phantom (F4).
5. Repair entry-point documentation so the layer is discoverable and honest about both
   runtimes (F6).

## Non-Goals

- **Claude Code skill wiring** (`.claude/skills/`). Phase 2 — deliberately separated so
  "does the loading mechanism work" is not entangled with "do we leave superpowers".
- **Forking away from superpowers** (F7): disabling the plugin, absorbing the 13 copies,
  rewriting the 39 cross-references, rebuilding the SessionStart hook.
- **A `workflows/` directory.** Rejected on evidence — no runtime reads one.
- **Converting the epic skills into an Antigravity Plugin.** Viable long-term bundling, but
  `plugin.json` is Antigravity-only and would regress Claude Code.
- **Changing what any skill does.** Only duplicated or incorrect orchestration prose is touched.
- **Retiring `.cursorrules` / `.kiro/` / `copilot-instructions.md`.** Their inaccurate
  `.agents/` descriptions are corrected, not removed.

---

## Architecture

### Tier responsibilities

| Tier | Owns | Must not own |
|---|---|---|
| **Rule** | Constraints true in every context | Sequence, branching |
| **Skill** | One reusable capability, self-sufficient | Knowledge of its position in a chain |
| **Workflow** | Sequence, gates, entry/exit criteria, artefact handoffs | The *how* of any single step |

The Workflow tier is **semantic, not structural**: Antigravity collapses workflows into
Skills by design, so `epic-lifecycle` ships as a skill whose sole job is orchestration. The
separation of concerns is preserved in content and naming; only the directory tier is dropped,
because a directory no runtime reads enforces nothing.

Test of correct layering: deleting one skill from the chain must leave the orchestrator still
describing the remainder accurately.

### `.agents/skills/epic-lifecycle/SKILL.md`

Frontmatter is restricted to `name` + `description` — the two documented fields, and the
convention used by all 28 existing skills (surveyed: zero use any other key). The workflow
nature is carried by the `description`, which is precisely the field both runtimes read to
decide activation; a non-standard `type:` key would add parse risk while influencing nothing.

Contents: one canonical Mermaid diagram replacing the three partial ones; the gate table below;
per-stage entry/exit criteria; artefact locations; the epic-scale-vs-single-feature routing
rule rescued from the `brainstorming` fork; and failure handling (which stage a failed gate
returns to).

| Gate | Name | Approver | Lives in | Handoff artefact |
|---|---|---|---|---|
| **1** | Spec Approved | User | end of `brainstorming` | `<epic>/YYYY-MM-DD-*-design.md` |
| **2** | HLD & Task Breakdown | User | `epic-designer` checkpoint | `<epic>.en.md` + `.vi.md` + `bdd_scenarios.md` + `task_*.md` |
| **3** | Execution Order — *newly defined* | User | `epic-implementation` Phase 1 | confirmed order + bootstrapped worktree |
| **4** | Quality LGTM | `quality_check` | `epic-implementation` Phase 4 | LGTM report + merge-ready branch |

### Skill changes — add a pointer, do not gut

Because Claude Code wiring is deferred, stripping orchestration out of the three skills would
leave them *worse* than today under that runtime. Therefore:

- **Keep** each skill's "how" intact and self-sufficient.
- **Remove** only the duplicated lifecycle diagram in `brainstorming` and the
  prerequisite/next-stage nodes in `epic-implementation` — the copies that disagree (F3).
- **Replace** each with a one-line pointer to `epic-lifecycle`.
- **Repoint** the dead `docs/architecture/EPIC_LIFECYCLE.md` link at the new skill, so the
  lifecycle has exactly one home.

### Configuration

`config.json` is read by no runtime — it is a convention the skills themselves honour by
reading the file. It is kept (the skills' `auto_commit` branch needs a real target) but made
truthful: `auto_commit` merged in, `config.yml` never created, `rules/CLAUDE.md` registered,
and `workflows_directory` removed since it names a tier that will not exist.

```json
{
  "rules": [".agents/rules/CRITICAL_RULES.md", ".agents/rules/CLAUDE.md"],
  "skills_directory": ".agents/skills",
  "auto_commit": true
}
```

The three call sites in `brainstorming` (×2) and `epic-designer` (×1) are updated to read
`config.json`.

### Root rule bridge: `AGENTS.md` real, `CLAUDE.md` symlink

One file, two names — Antigravity reads `AGENTS.md`, Claude Code reads `CLAUDE.md`, and a
symlink makes divergence structurally impossible.

The file is a thin pointer, not a copy:

```markdown
@.agents/rules/CRITICAL_RULES.md
@.agents/rules/CLAUDE.md
```

This is correct under both runtimes for different reasons, and duplicates nothing:

- **Claude Code** resolves `@path` imports and thereby loads the rules.
- **Antigravity** already auto-loads `.agents/rules/*.md` natively; the `@` lines are inert
  text to it. Because Antigravity deduplicates rules *by resolved file path*, and these are
  pointers rather than copies, no rule is injected twice.

**Open risk:** Claude Code's `@path` import is believed supported but unverified here. Since
the entire value of this change is "do the rules actually load", verification in a fresh
Claude Code session is a mandatory acceptance step, not an assumption. Fallback: move the rule
bodies into the root file and leave `.agents/rules/` pointing back at it.

### Documentation repair

- Create `.agents/README.md` — the real index of Rules / Skills / the orchestrator, stating
  plainly which runtime loads what. Both `AI_AGENT_README.md` and `.cursorrules` already point
  at this file.
- Rewrite `AI_AGENT_README.md`: drop the foreign absolute path, repair all six dead targets,
  correct the skill names.
- Correct the `.agents/` layout and discovery protocol described in `.cursorrules` to match disk.

---

## Alternatives Considered

**A `.agents/workflows/` directory (the original plan).** Rejected on evidence discovered
mid-design: not an Antigravity customization type and not a Claude Code load path, so it would
have created a third orphan of exactly the kind this work exists to remove.

**Merging the three epic skills into one "epic workflow" skill.** Rejected: the skills are
already correctly single-purpose. The defect is an absent orchestrator, not the skills.
Merging would yield one oversized file and destroy reusability.

**An Antigravity Plugin (`.agents/plugins/epic/`).** The most idiomatic long-term bundling of
skills + rules + MCP, and worth revisiting. Rejected now because `plugin.json` is
Antigravity-only and would regress the Claude Code path.

**Big-bang fork of superpowers.** Rejected for this phase: concentrates all risk; a failure in
the loading mechanism would cost both the local skills and the plugin at once.

---

## Testing Strategy

No product code changes, so verification is structural plus two behavioural checks that must
run in **fresh sessions of each runtime**:

1. **Link integrity** — every relative link in `.agents/**`, `AI_AGENT_README.md`, and
   `.cursorrules` resolves to a real path.
2. **Config coherence** — no file in `.agents/` references `config.yml`; every path in
   `config.json` exists; `workflows_directory` is gone.
3. **Gate completeness** — gates 1–4 appear exactly once each in `epic-lifecycle`, no gaps,
   each mapping to a real checkpoint in the owning skill.
4. **Frontmatter validity** — `epic-lifecycle/SKILL.md` carries exactly `name` + `description`,
   matching the contract and the other 28 skills.
5. **Rule loading, Claude Code (blocking)** — new session; confirm `CRITICAL_RULES.md` and
   `rules/CLAUDE.md` content is in context *before* any file is read. If absent, apply the
   fallback above. This is the acceptance test for the bridge.
6. **Skill activation, Antigravity (blocking)** — new session; confirm `epic-lifecycle` appears
   among available skills and activates on an epic-scale request.
7. **No behavioural drift** — diff the three edited skills; only diagram and pointer lines
   changed.

---

## Risks

| Risk | Mitigation |
|---|---|
| `@path` import unsupported → rules still never load in Claude Code | Blocking check 5; documented fallback |
| `epic-lifecycle` exists but nothing routes to it under Claude Code (F2 persists) | Root rule file names it; full cure is Phase 2 |
| Symlinked `CLAUDE.md` mishandled by a tool that copies rather than follows links | Check 5 catches it; `AGENTS.md` remains the real file |
| Phase 2 never happens; `.agents/` drifts further from `superpowers@6.3.0` | F7 records the exact 13 skills and 39 reference sites so Phase 2 starts from fact |
| `.agents/rules/CLAUDE.md` is confusingly named — it is a generic guideline file loaded chiefly by *Antigravity* | Flagged; rename deferred to avoid scope creep |

---

## References

- Antigravity Customization System Guide — extracted from
  `/Applications/Antigravity.app/Contents/Resources/bin/language_server` (authoritative source
  for every Antigravity claim in this spec)
- `.agents/config.json` — declared the workflows tier this spec removes
- `.agents/skills/brainstorming/SKILL.md` — diverged fork (F2), source of the routing rule
- `.agents/skills/epic-designer/SKILL.md`, `.agents/skills/epic-implementation/SKILL.md` — gate owners (F3)
- `docs/superpowers/specs/2026-08-26-epic-implementation-design.md` — the execution model sequenced here
- Upstream baseline for Phase 2: `superpowers@6.3.0`
