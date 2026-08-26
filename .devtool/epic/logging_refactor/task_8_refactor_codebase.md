---
id: "task_8_refactor_codebase"
status: "done"
priority: "medium"
assignee: null
epic: "logging-refactor"
dueDate: null
created: "2026-08-25T19:00:00.000Z"
modified: "2026-08-26T07:28:00.000Z"
completedAt: "2026-08-26T07:28:00.000Z"
labels: ["refactor", "cleanup"]
order: "a8"
---
# Task 8: Refactor Existing Codebase to D3NexusLogger

Epic: [logging_refactor](../epic/logging_refactor/logging_refactor.en.md)

## Requirement Analysis
Complete the migration from the old static `Log` wrapper to `D3NexusLogger` across all existing call sites (~10 today, e.g. `packages/settings/lib/presentation/settings/settings_bloc.dart`, `packages/core/lib/localization/localization_manager.dart`, `packages/framework/lib/mvi_bloc.dart`, `packages/framework/lib/mixin/dialog_mixin.dart`), then remove the old `Log` wrapper and its dependencies entirely, per the Epic HLD's phased rollout (Phase 2-4).

## Relevant Files & Context Pointers
- `packages/core/lib/utils/log.dart` — old `Log` wrapper; mark `@Deprecated` and delegate to `D3NexusLogger` first, then delete once all call sites are migrated.
- `packages/settings/lib/presentation/settings/settings_bloc.dart` — `Log.e(...)` call site.
- `packages/core/lib/localization/localization_manager.dart` — multiple `Log.d(...)` call sites.
- `packages/framework/lib/mvi_bloc.dart` — `Log.i(...)` call site.
- `packages/framework/lib/mixin/dialog_mixin.dart` — `Log.d(...)` call site.
- `packages/network/pubspec.yaml` — remove `talker_dio_logger`/`talker_bloc_logger` once their replacement appenders (Task 4/5) are wired.
- (Run `grep -rn "Log\.\(d\|i\|w\|e\|v\)(" --include="*.dart" packages lib` at the start of this task to get the authoritative, current call-site list — it may have grown since this task was written.)

## Design Rationale
**Phased, revertible migration** (Epic HLD §5): Phase 2 makes `Log` delegate internally to `D3NexusLogger` so nothing breaks while call sites are migrated incrementally; Phase 3 does the actual mass replace on a dedicated branch; Phase 4 deletes the old wrapper and its now-unused dependencies. This ordering means Phase 3/4 can be rolled back without re-touching call sites, since Phase 2's shim is the safety net.

Relevant project skills: `using-git-worktrees` (`.agent/skills/using-git-worktrees`) for isolating the mass-replace branch; `verification-before-completion` (`.agent/skills/verification-before-completion`) before declaring the migration done.

## TDD Adaptation
This is a mass find/replace with no new behavior (call sites keep the same log semantics, just a new API) — RED/GREEN/REFACTOR doesn't apply. Concrete steps instead:
- [ ] Mark `Log` in `packages/core/lib/utils/log.dart` `@Deprecated('Use D3NexusLogger instead')` and make it delegate to `D3NexusLogger.getLogger('Legacy')` internally (Phase 2).
- [ ] On a dedicated branch, replace every `Log.d/i/w/e/v(...)` call site with `D3NexusLogger.getLogger('<Module>').d/i/w/e/v(...)`, using each call site's owning package name as `<Module>` (Phase 3).
- [ ] Delete `packages/core/lib/utils/log.dart` and remove `talker_dio_logger`/`talker_bloc_logger` from `packages/network/pubspec.yaml` (Phase 4).
- [ ] Run `melos run analyze` and the full test suite across all packages to confirm no regression.

## Definition of Done (DoD)
- [ ] Zero remaining references to the old `Log` class (`grep -rn "Log\.\(d\|i\|w\|e\|v\)(" packages lib` returns no results).
- [ ] `packages/core/lib/utils/log.dart` deleted.
- [ ] `talker_dio_logger`/`talker_bloc_logger` removed from `packages/network/pubspec.yaml`.
- [ ] `melos run analyze` and full test suite pass across all packages.

## Dependencies & Blockers
- **Dependencies**: Blocked by [Task 4](task_4_appenders_di.md) (app-layer appenders must exist so `D3NexusLogger` is fully functional before call sites migrate) and [Task 5](task_5_network_tracing.md) (network tracing must be in place before removing `talker_dio_logger`).

## References & Rollback
- **References**: Epic HLD §5 [Rollout Strategy & Mitigation](../epic/logging_refactor/logging_refactor.en.md#5-rollout-strategy--mitigation).
- **Rollback Plan**: Because Phase 2's delegation shim is committed separately from Phase 3's mass replace, revert only the Phase 3/4 commits to fall back to the old `Log` API surface without touching call sites again.
