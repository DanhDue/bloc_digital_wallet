---
id: "task_3_log_manager"
status: "todo"
priority: "high"
assignee: null
epic: "logging-refactor"
dueDate: null
created: "2026-08-25T19:00:00.000Z"
modified: "2026-08-25T19:00:00.000Z"
completedAt: null
labels: ["core", "tdd"]
order: "a3"
---
# Task 3: Implement LogManagerImpl & Trace Tree

Epic: [logging_refactor](../epic/logging_refactor/logging_refactor.en.md)

## Requirement Analysis
This is the heart of the dispatch logic: `LogManagerImpl` must route each `LogRecord` to every registered `ILogAppender`, honoring two independent toggles — per-module (debug-only mute, respected only by appenders that opt in via `respectsModuleToggle`) and per-appender (a full kill switch, e.g. to disable Datadog at runtime). It must also provide `buildTraceTree`, a pure function that reconstructs the causal call sequence for a `traceId` from `spanId`/`parentSpanId` relationships.

## Relevant Files & Context Pointers
- `packages/logger/lib/src/log_manager_impl.dart` — new, implements `ILogManager`.
- `packages/logger/lib/src/trace_tree.dart` — new, `TraceNode` model + `buildTraceTree(List<LogRecord>)`.
- `packages/logger/lib/src/i_log_manager.dart`, `i_log_appender.dart` — interfaces from [Task 2](task_2_core_interfaces.md) this implements against.
- `packages/logger/test/log_manager_impl_test.dart` — new, dispatch-matrix tests.
- `packages/logger/test/trace_tree_test.dart` — new, tree-reconstruction tests.

## Design Rationale
**Single dispatch gate, per-appender opt-out**: `LogManagerImpl.log()` evaluates `appenderToggles[appender.id]` first (hard kill switch, applies to every appender), then `moduleToggles[record.module] && appender.respectsModuleToggle` (soft, debug-only mute) — see the dispatch pseudocode in the Epic HLD §4.1. This ordering guarantees muting a module for local debugging can never silently blind Datadog/Otel in production, which was the explicit design decision behind splitting the two toggle maps. `buildTraceTree` is kept as a pure function (input `List<LogRecord>` → output `List<TraceNode>`) so it's trivially unit-testable and reusable by any appender/UI, not just Talker.

Relevant project skill: `test-driven-development` (`.agent/skills/test-driven-development`) — the dispatch matrix (module × appender toggle combinations) is exactly the kind of branching logic that skill's test-first process is meant to pin down before implementation.

## TDD Checklist
- [ ] **RED**: Write unit tests covering the full dispatch matrix — appender disabled (skip regardless of module), appender enabled + module disabled + `respectsModuleToggle=true` (skip), appender enabled + module disabled + `respectsModuleToggle=false` (still dispatched), appender enabled + module enabled (dispatched). Write tests for `buildTraceTree` — flat list with no parent, single-parent chain, multiple branches from one parent, and records with an unknown `parentSpanId` (must not crash, treated as a root).
- [ ] **GREEN**: Implement `LogManagerImpl` and `buildTraceTree` to satisfy the tests above.
- [ ] **REFACTOR**: Extract the dispatch predicate into a small named function if the branching in `log()` grows hard to read; ensure `LogManagerImpl` has no dependency on any concrete appender type.

## Definition of Done (DoD)
- [ ] Full dispatch-matrix coverage in tests (all 4 toggle combinations above).
- [ ] `buildTraceTree` covered for chain, branch, and orphan-parent cases.
- [ ] Test coverage for this package/layer > 80%; `dart analyze` passes 100%.

## Dependencies & Blockers
- **Dependencies**: Blocked by [Task 2](task_2_core_interfaces.md) (interfaces and `LogRecord` must exist first).

## References & Rollback
- **References**: Epic HLD §4.1 dispatch pseudocode — [logging_refactor.en.md](../epic/logging_refactor/logging_refactor.en.md#41-high-level-architecture).
- **Rollback Plan**: Revert this task's commit; `LogManagerImpl` and `buildTraceTree` are new files with no existing call sites yet, so rollback has no ripple effect elsewhere.
