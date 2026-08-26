---
id: "task_1_create_package"
status: "done"
priority: "high"
assignee: null
epic: "logging-refactor"
dueDate: null
created: "2026-08-25T19:00:00.000Z"
modified: "2026-08-26T02:09:48.000Z"
completedAt: "2026-08-26T02:09:48.000Z"
labels: ["package", "core"]
order: "a1"
---
# Task 1: Create `logger` Package (Pure Dart)

Epic: [logging_refactor](../epic/logging_refactor/logging_refactor.en.md)

## Requirement Analysis
The current logging system (`packages/core/lib/utils/log.dart`) is hard-coupled to `talker_flutter` and lives inside `packages/core`, which blocks the goal of swapping/adding telemetry backends (Datadog, Otel) without touching core. This task scaffolds the new pure-Dart `packages/logger` package as an empty, dependency-free foundation for the rest of the epic.

## Relevant Files & Context Pointers
- `packages/core/lib/utils/log.dart` — current `Log` wrapper, source of the `talker_flutter` dependency to remove from core.
- `packages/core/pubspec.yaml` — remove `talker_flutter` from here.
- `melos.yaml` — register the new `packages/logger` package.
- `packages/logger/` — new package to scaffold (does not exist yet).

## Design Rationale
**Dependency Isolation & Federated Packages**: extracting `logger` as a pure-Dart package keeps it free of any concrete telemetry SDK, so feature packages (`wallet`, `home`, ...) that depend on `logger` never transitively pull in Talker/Datadog/Otel. This is the foundation for Task 2-3's Dependency Inversion (core defines interfaces only; the app layer decides which concrete SDK to use).

Relevant project skill: `create_new_feature` (`.agent/skills/create_new_feature`) covers this repo's convention for scaffolding a new package/module — follow it for package structure and melos wiring.

## TDD Adaptation
This task is infrastructure scaffolding with no testable behavior yet (an empty package has nothing to assert against) — RED/GREEN/REFACTOR doesn't apply. Concrete steps instead:
- [ ] Run `flutter create --template=package packages/logger`.
- [ ] Add `logger` to the package list in `melos.yaml`.
- [ ] Remove the `talker_flutter` dependency from `packages/core/pubspec.yaml` (it moves to the app layer in Task 4).
- [ ] Run `melos bootstrap` to relink dependencies.
- [ ] Run `melos run analyze` to confirm no regressions from removing `talker_flutter` out of `packages/core` (expected to fail until Task 8 removes the old `Log` usages — track as a known, temporary break resolved by Task 2's deprecation shim).

## Definition of Done (DoD)
- [ ] `packages/logger` exists, is registered in `melos.yaml`, and `melos bootstrap` succeeds.
- [ ] `talker_flutter` is no longer a direct dependency of `packages/core`.
- [ ] `dart analyze` on `packages/logger` passes with zero errors.

## Dependencies & Blockers
- **Dependencies**: None.
- **Blockers**: None.

## References & Rollback
- **References**: [Melos Documentation](https://melos.invertase.dev/).
- **Rollback Plan**: `git revert` this task's commit; re-add `talker_flutter` to `packages/core/pubspec.yaml` and delete `packages/logger/` if bootstrap fails irrecoverably.
