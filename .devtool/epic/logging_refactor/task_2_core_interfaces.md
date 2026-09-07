---
id: "task_2_core_interfaces"
status: "done"
priority: "high"
assignee: null
epic: "logging-refactor"
dueDate: null
created: "2026-08-25T19:00:00.000Z"
modified: "2026-08-26T02:21:01.000Z"
completedAt: "2026-08-26T02:21:01.000Z"
labels: ["interfaces", "architecture", "tdd"]
order: "a2"
---
# Task 2: Define Core Interfaces & LogRecord

Epic: [logging_refactor](../epic/logging_refactor/logging_refactor.en.md)

## Requirement Analysis
Every module needs a single, backend-agnostic way to emit a log entry that carries enough structure (module, level, traceId/spanId/parentSpanId) for downstream dispatch, module/appender toggling, and sequence reconstruction. This task defines `LogRecord` and the `ILogger`/`ILogAppender`/`ILogManager` interfaces plus the `D3NexusLogger` static facade, with no concrete implementation yet.

## Relevant Files & Context Pointers
- `packages/logger/lib/src/log_record.dart` — new, `LogRecord` data class.
- `packages/logger/lib/src/i_log_appender.dart` — new, `ILogAppender` interface (`id`, `respectsModuleToggle`, `append`).
- `packages/logger/lib/src/i_logger.dart` — new, `ILogger` interface (`d/i/w/e/v`, `withSpan`).
- `packages/logger/lib/src/i_log_manager.dart` — new, `ILogManager` interface.
- `packages/logger/lib/d3nexus_logger.dart` — new, main export + `D3NexusLogger` static facade.
- `packages/core/lib/utils/log.dart` — old `Log` API shape to preserve semantics (`d/i/w/e/v`) for a smooth Task 8 migration.

## Design Rationale
**Interface Segregation & Dependency Inversion**: splitting `ILogger`/`ILogAppender`/`ILogManager` keeps each concern replaceable and mockable in isolation. `LogRecord` embeds `traceId`/`spanId`/`parentSpanId` (W3C Trace Context / OpenTelemetry span model) so sequence reconstruction (Task 3) doesn't need to bolt correlation on later. `D3NexusLogger` is a static facade (mirrors the old `Log` static API) so call sites that can't easily use DI still have a simple entry point.

Relevant project skill: `test-driven-development` (`.agents/skills/test-driven-development`) — this task is interface + data-class design and should be driven test-first per that skill's process.

## TDD Checklist
- [ ] **RED**: Write unit tests for `LogRecord` (construction, immutability, `traceId`/`spanId`/`parentSpanId` fields) and for `D3NexusLogger` (throws if used before `initialize()`, `getLogger()` returns a distinct logger per module, `withSpan()` stamps a new `spanId` with `parentSpanId` set to the current span).
- [ ] **GREEN**: Implement `LogRecord`, `ILogAppender`, `ILogger`, `ILogManager`, and `D3NexusLogger` to make the above tests pass — no concrete appender or manager logic yet (that's Task 3).
- [ ] **REFACTOR**: Clean up, add `///` doc comments to all public APIs, ensure exports are consolidated in `packages/logger/lib/d3nexus_logger.dart`.

## Definition of Done (DoD)
- [ ] Test coverage for this package/layer > 80%.
- [ ] All interfaces defined and consistent with SOLID (no concrete SDK types leak into signatures).
- [ ] `dart analyze` passes 100%.

## Dependencies & Blockers
- **Dependencies**: Blocked by [Task 1](task_1_create_package.md) (package must exist first).

## References & Rollback
- **References**: [W3C Trace Context Specification](https://www.w3.org/TR/trace-context/).
- **Rollback Plan**: Revert the interface-definition commit if the shape doesn't hold up under Task 3/4's concrete implementations; no other code depends on these interfaces yet at this point in the epic.
