---
id: "task_4_appenders_di"
status: "todo"
priority: "high"
assignee: null
epic: "logging-refactor"
dueDate: null
created: "2026-08-25T19:00:00.000Z"
modified: "2026-08-25T19:00:00.000Z"
completedAt: null
labels: ["app-layer", "di", "tdd"]
order: "a4"
---
# Task 4: App-Layer Appenders & DI Integration

Epic: [logging_refactor](../epic/logging_refactor/logging_refactor.en.md)

## Requirement Analysis
Concrete backends (Talker, Datadog, Otel) must live outside `packages/logger` so the core never depends on any SDK. This task implements `TalkerAppender`, `DatadogAppender`, and `OtelAppender` in the app layer, wires them into `D3NexusLogger` via the app's existing DI setup at bootstrap, and sets environment-based default registration (e.g. dev registers only Talker; staging/prod also register Datadog/Otel).

## Relevant Files & Context Pointers
- `lib/logging/appenders/talker_appender.dart` — new, wraps `talker_flutter` (moved here from `packages/core`).
- `lib/logging/appenders/datadog_appender.dart` — new.
- `lib/logging/appenders/otel_appender.dart` — new.
- `lib/di/injection.dart`, `lib/di/injection.config.dart` — existing app DI setup (injectable/get_it) where appenders get registered and `D3NexusLogger.initialize()` is called.
- `pubspec.yaml` (root app) — add `talker_flutter` (moved from `packages/core`), Datadog/Otel SDK dependencies here.

## Design Rationale
**Appenders as app-layer glue, not separate packages**: each appender is a thin (~30-50 line) adapter implementing `ILogAppender`. Splitting each into its own pub package was considered and rejected — the isolation that matters ("swap backend without touching core") is delivered entirely by the `ILogAppender` interface boundary in `packages/logger`, not by physical package boundaries; three near-single-file packages would only add pubspec/melos/CI overhead in this single-app monorepo. `TalkerAppender.respectsModuleToggle = true`; `DatadogAppender`/`OtelAppender`.`respectsModuleToggle = false` (see Task 3's dispatch logic).

Relevant project skill: `mobile-developer` (`.agent/skills/mobile-developer`) for the DI/bootstrap wiring conventions used elsewhere in this app.

## TDD Checklist
- [ ] **RED**: Write unit tests per appender — `TalkerAppender.append()` forwards to the underlying `Talker` instance with the right level mapping; `DatadogAppender`/`OtelAppender.append()` call their SDK's log/span API with `traceId`/`spanId` mapped correctly. Write a DI-wiring test asserting `D3NexusLogger` resolves with the environment-appropriate appender set (dev vs. staging/prod).
- [ ] **GREEN**: Implement the three appenders and the DI registration/bootstrap wiring to pass the tests.
- [ ] **REFACTOR**: Ensure no appender file is imported anywhere under `packages/logger`; confirm `packages/logger`'s `pubspec.yaml` still has zero SDK dependencies.

## Definition of Done (DoD)
- [ ] All three appenders implemented and unit-tested with mocked SDK clients.
- [ ] `D3NexusLogger.initialize()` is called once at app bootstrap with the environment-correct appender set.
- [ ] `packages/logger/pubspec.yaml` contains no `talker_flutter`/Datadog/Otel dependency (verified by `dart analyze`/dependency check).

## Dependencies & Blockers
- **Dependencies**: Blocked by [Task 3](task_3_log_manager.md) (`LogManagerImpl`/`ILogAppender` must exist first).

## References & Rollback
- **References**: [injectable package docs](https://pub.dev/packages/injectable) (matches this repo's existing DI convention).
- **Rollback Plan**: Revert this task's commit; since the old `Log`/`talker_flutter` wiring in `packages/core` is untouched until Task 8, the app keeps working on the old logger if this rolls back.
