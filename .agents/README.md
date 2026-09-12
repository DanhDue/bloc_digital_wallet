# `.agents/` — Agent Customization Layer

This directory is the single source of truth for how AI agents behave in this repository.
It follows the **Antigravity Customization System** layout, which Antigravity discovers
automatically at the repo root.

## Which runtime loads what

This matters more than anything else on this page. The two runtimes used here do **not** see
the same files.

| Asset | Antigravity | Claude Code |
|---|---|---|
| `rules/*.md` | ✅ native (`trigger: always_on` loads unconditionally) | ↩ via root `CLAUDE.md` imports |
| `skills/<name>/SKILL.md` | ✅ native, workspace priority beats built-ins | ✅ via the `d3nexus` plugin, as `d3nexus:<skill>` |
| `config.json` | ❌ not a runtime file | ❌ not a runtime file |
| root `AGENTS.md` | ✅ native rule | ✅ via the `CLAUDE.md` symlink |

Root `CLAUDE.md` is a **symlink to `AGENTS.md`** — one file, two names, so the two runtimes can
never drift apart.

## Layout

```
.agents/
├── README.md          # this index
├── config.json        # conventions the skills themselves read (auto_commit, rule registry)
├── rules/             # always-on behavioural constraints
└── skills/<name>/     # on-demand capabilities; each has a SKILL.md
```

Claude Code reaches these through the **`d3nexus` plugin**, not this directory. A
`.claude/skills` symlink does not work: Claude Code skips any directory entry that is a
symlink (`unsafe or symlinked skill folder`), so only real files or a plugin are loaded.

Skills are loaded by **progressive disclosure**: only `name` and `description` enter the context
window, and the body is read when the skill activates. Keep `SKILL.md` concise and push bulky
material into the skill's own `references/`, `scripts/`, `resources/` or `examples/`
subdirectory.

## Rules

Rules are always-on and runtime-agnostic. Anything that is really *audit criteria* lives with the
audit skill that applies it, not here.

| File | Purpose |
|---|---|
| [rules/CRITICAL_RULES.md](rules/CRITICAL_RULES.md) | Mandatory. Run `quality_check` after completing any workflow or skill. |
| [rules/CLAUDE.md](rules/CLAUDE.md) | Behavioural guidelines: think first, simplicity, surgical changes, verify. |

**Flutter house conventions** (Clean Architecture + MVI wiring, Freezed/Retrofit rules, naming,
formatting, security baseline) are not rules — they are consulted during `quality_check` from the
audit skill that enforces them:

| Reference | Owned by |
|---|---|
| [AutoRoute, GetIt/Injectable, MVI naming, Retrofit `baseUrl`](skills/architecture-audit/references/flutter-project-baseline.md) | `architecture-audit` |
| [Imports, Freezed contract, naming, formatting, Dart style](skills/code-health-audit/references/flutter-project-baseline.md) | `code-health-audit` |
| [Client timeouts, error surfacing, input validation](skills/security-audit/references/flutter-project-baseline.md) | `security-audit` |

## Skills

### Orchestration

| Skill | Use it for |
|---|---|
| [epic-lifecycle](skills/epic-lifecycle/SKILL.md) | **Start here for epic-scale work.** Owns the 4 stages and 4 approval gates. |
| [epic-designer](skills/epic-designer/SKILL.md) | Stage 2 — HLD, Mermaid diagrams, BDD scenarios, Kanban task breakdown. |
| [epic-implementation](skills/epic-implementation/SKILL.md) | Stage 3 — execute an approved epic's tasks in an isolated worktree. |
| [dispatching-parallel-agents](skills/dispatching-parallel-agents/SKILL.md) | 2+ genuinely independent tasks with no shared state. |
| [subagent-driven-development](skills/subagent-driven-development/SKILL.md) | Execute plan tasks via subagents in the current session. |

### Process

| Skill | Use it for |
|---|---|
| [brainstorming](skills/brainstorming/SKILL.md) | Required before any creative work. Idea → approved spec. |
| [writing-plans](skills/writing-plans/SKILL.md) | Spec → implementation plan, for non-epic work. |
| [executing-plans](skills/executing-plans/SKILL.md) | Run a written plan in a separate session. |
| [test-driven-development](skills/test-driven-development/SKILL.md) | Any feature or bugfix, before implementation code. |
| [systematic-debugging](skills/systematic-debugging/SKILL.md) | Any bug or test failure, before proposing fixes. |
| [using-git-worktrees](skills/using-git-worktrees/SKILL.md) | Isolate feature work from the current workspace. |
| [finishing-a-development-branch](skills/finishing-a-development-branch/SKILL.md) | Integrate completed work. |
| [verification-before-completion](skills/verification-before-completion/SKILL.md) | Before claiming anything is done, fixed, or passing. |
| [requesting-code-review](skills/requesting-code-review/SKILL.md) / [receiving-code-review](skills/receiving-code-review/SKILL.md) | Both sides of review. |

### Quality & Audit

| Skill | Use it for |
|---|---|
| [quality_check](skills/quality_check/SKILL.md) | **Mandatory after any workflow.** 3-Tier suite + the 4 audits below, in parallel. |
| [security-audit](skills/security-audit/SKILL.md) | Mobile fintech security, OWASP Mobile Top 10, financial precision. |
| [architecture-audit](skills/architecture-audit/SKILL.md) | Clean Architecture, domain purity, module isolation, MVI state. |
| [code-health-audit](skills/code-health-audit/SKILL.md) | Clean code, function sizing, argument limits. |
| [flutter-ui-audit](skills/flutter-ui-audit/SKILL.md) · [android-ui-audit](skills/android-ui-audit/SKILL.md) · [ios-ui-audit](skills/ios-ui-audit/SKILL.md) | Platform UI audits. |
| [pr_review](skills/pr_review/SKILL.md) | Full PR review orchestrating the 3-Tier suite and audits. |

### Build & Environment

| Skill | Use it for |
|---|---|
| [setup_build](skills/setup_build/SKILL.md) | Make a checkout buildable: verify → copy → variants → build one flavor. |
| [setup_variants](skills/setup_variants/SKILL.md) | First-time dev/stg/prd flavor setup for Android and iOS. |
| [check_secure_files](skills/check_secure_files/SKILL.md) | Verify the `secureFiles/` contents before building. |
| [copy_secure_configurations](skills/copy_secure_configurations/SKILL.md) | Place `google-services.json` / `GoogleService-Info.plist` into platform paths. |
| [secrets_env](skills/secrets_env/SKILL.md) | Recover `secureFiles/` from the `SECURE_FILES` environment variable. |
| [melos_sync](skills/melos_sync/SKILL.md) | Dependency or generated-code errors after pulling changes. |
| [build_fix](skills/build_fix/SKILL.md) | Systematically clear Flutter analyzer and build errors. |
| [setup_keybindings](skills/setup_keybindings/SKILL.md) · [setup_local_keybindings](skills/setup_local_keybindings/SKILL.md) | Editor keybinding setup. |

### Feature & API Tooling

| Skill | Use it for |
|---|---|
| [create_new_feature](skills/create_new_feature/SKILL.md) | New Flutter feature or subfeature via Mason + Clean Architecture/MVI. |
| [api_integration](skills/api_integration/SKILL.md) | Flutter: new API request end to end, model generation → data source. |
| [json_to_freezed_model](skills/json_to_freezed_model/SKILL.md) | Raw JSON → Freezed Dart models. |
| [android-api-integration](skills/android-api-integration/SKILL.md) | Android: network module, API interface, data source, repository, use case. |
| [moshi_dto_generator](skills/moshi_dto_generator/SKILL.md) | Raw JSON → production Moshi DTOs. |

### Meta

| Skill | Use it for |
|---|---|
| [writing-skills](skills/writing-skills/SKILL.md) | Creating, editing, or verifying skills. |
| [using-superpowers](skills/using-superpowers/SKILL.md) | How to find and use skills. |
| [session_init](skills/session_init/SKILL.md) | Start a session: establish name, focus area, and context to load. |
| [task-observer](skills/task-observer/SKILL.md) | Task tracking and review cadence. |
| [find-skills](skills/find-skills/SKILL.md) | Discover and install skills from the public ecosystem. |

## Known Gaps

Recorded deliberately so they are not rediscovered. Full analysis:
[`docs/superpowers/specs/2026-09-12-agents-workflow-layer-design.md`](../docs/superpowers/specs/2026-09-12-agents-workflow-layer-design.md).

1. **Skill references are addressed differently per distribution.** In this repo the skills are
   project skills (via `.claude/skills` → `../.agents/skills`) and reference each other by bare
   name. The same skills published as the `d3nexus` plugin address each other as
   `d3nexus:<skill>`. Keep that in mind when copying a skill between the two.
2. **13 skills are byte-identical copies of `superpowers@6.3.0`** and 39 `superpowers:*`
   cross-references remain in this tree. Under Antigravity the local copies win; under Claude
   Code the plugin's copies do. Only `brainstorming` has diverged — which is why its epic
   routing works in Antigravity and not in Claude Code. Phase 2 resolves this.
