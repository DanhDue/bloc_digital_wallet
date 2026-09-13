# `.agents/` — Agent Customization Layer

This project no longer vendors its own skills. They come from the **`d3nexus`** agent kit
([DanhDue/ai-agent-tools](https://github.com/DanhDue/ai-agent-tools)), installed once per machine
and shared by every mobile project — one source, no drift.

What stays here is only what is genuinely project-specific: the rules and the conventions the
skills read.

## Which runtime loads what

| Asset | Antigravity | Claude Code |
|---|---|---|
| Skills | `d3nexus` plugin in `~/.gemini/config/plugins/` | `d3nexus` plugin, invoked as `d3nexus:<skill>` |
| `rules/*.md` | ✅ native (`trigger: always_on` loads unconditionally) | ↩ via the root `CLAUDE.md` imports |
| `config.json` | ❌ not a runtime file | ❌ not a runtime file |
| root `AGENTS.md` | ✅ native rule | ✅ via the `CLAUDE.md` symlink |

Root `CLAUDE.md` is a **symlink to `AGENTS.md`** — one file, two names, so the two runtimes can
never drift apart.

> [!IMPORTANT]
> Do not re-create `.agents/skills/` here. Antigravity ranks **workspace above global**, so a
> vendored copy silently overrides the plugin in this project only — which is exactly the drift
> this layout removes. Edit skills in the kit instead; see [Working on the skills](#working-on-the-skills).

## Layout

```
.agents/
├── README.md          # this file
├── config.json        # conventions the skills read (auto_commit, rule registry)
└── rules/             # always-on behavioural constraints
```

## Rules

| File | Purpose |
|---|---|
| [rules/CRITICAL_RULES.md](rules/CRITICAL_RULES.md) | Mandatory: run `quality_check` after any workflow; the commit message format. |
| [rules/CLAUDE.md](rules/CLAUDE.md) | Behavioural guidelines: think first, simplicity, surgical changes, verify. |

Rules stay thin and runtime-agnostic. Flutter house conventions that are really *audit criteria*
(Clean Architecture wiring, the Freezed contract, naming and formatting, the security baseline)
live with the audit skill that enforces them, inside the kit at
`skills/<audit>/references/flutter-project-baseline.md`, so `quality_check` loads them only when
it actually audits a Flutter project.

## Skills

Run `claude plugin details d3nexus` for the full inventory of the 42 skills and their token cost.
Start with **`epic-lifecycle`** for anything epic-scale — it owns the four stages and four
approval gates and routes to the right skill at each step.

| Situation | Skill |
|---|---|
| Epic-scale work (multiple components, needs HLD + task breakdown) | `epic-lifecycle` |
| Any new feature, component, or behaviour change | `brainstorming` |
| A bug, test failure, or unexpected behaviour | `systematic-debugging` |
| Finished a workflow or skill | `quality_check` (mandatory — see CRITICAL_RULES) |
| A checkout that will not build | `setup_build` |
| Dependency or codegen errors after pulling | `melos_sync` |

## Working on the skills

Skills are edited in the kit's working clone, not here:

```bash
cd ~/AllProjects/ai-agent-tools
$EDITOR skills/epic-lifecycle/SKILL.md
scripts/verify.sh
```

Opening [`bloc_digital_wallet.code-workspace`](../bloc_digital_wallet.code-workspace) puts that
clone in the sidebar next to this project, so the source is one click away.

Publishing is a separate, deliberate step — see the kit's README. A release pushes to every
machine, so it happens only when you ask for it.
