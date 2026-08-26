---
id: "task_5_network_tracing"
status: "done"
priority: "medium"
assignee: null
epic: "logging-refactor"
dueDate: null
created: "2026-08-25T19:00:00.000Z"
modified: "2026-08-26T02:49:05.000Z"
completedAt: "2026-08-26T02:49:05.000Z"
labels: ["network", "tracing", "tdd"]
order: "a5"
---
# Task 5: Network Trace Propagation (traceparent)

Epic: [logging_refactor](../epic/logging_refactor/logging_refactor.en.md)

## Requirement Analysis
For traceId/spanId to be useful beyond the client, the active trace context must be propagated across the network boundary. This task adds a Dio interceptor in `packages/network` that injects a standard W3C `traceparent` header built from the current `D3NexusLogger` trace context, so a backend instrumented with Otel/APM can continue the same trace.

## Relevant Files & Context Pointers
- `packages/network/lib/` — existing Dio client setup, currently also home to `talker_dio_logger` (moves out to the app layer per Task 4/8).
- `packages/network/lib/src/interceptors/` — new interceptor file for `traceparent` injection.
- `packages/logger/lib/d3nexus_logger.dart` — exposes the current trace context (`traceId`/`spanId`) this interceptor reads from.
- `packages/network/test/` — existing test directory for interceptor tests.

## Design Rationale
**W3C `traceparent` header**: format `version-traceId-parentId-flags`, built from the request's active `traceId`/`spanId`. This directly reuses the span model already defined in [Task 2](task_2_core_interfaces.md)/[Task 3](task_3_log_manager.md), so no separate trace-ID scheme is needed for network calls — the same IDs a developer sees in `buildTraceTree` on-device are the ones sent to the backend.

Relevant project skill: `api_integration` (`.agent/skills/api_integration`) for this repo's Dio/interceptor conventions.

## TDD Checklist
- [ ] **RED**: Write a unit test asserting the interceptor adds a `traceparent` header matching the W3C format for an active trace context, and a test asserting no header (or a fresh trace) is added when no trace context is active.
- [ ] **GREEN**: Implement the interceptor and register it in the existing Dio client setup.
- [ ] **REFACTOR**: Confirm the interceptor has no dependency on any concrete appender (Talker/Datadog/Otel) — it only reads trace context off `D3NexusLogger`.

## Definition of Done (DoD)
- [ ] Interceptor unit-tested for both "active trace" and "no active trace" cases.
- [ ] Header format matches the W3C Trace Context spec.
- [ ] `dart analyze` passes 100% on `packages/network`.

## Dependencies & Blockers
- **Dependencies**: Blocked by [Task 2](task_2_core_interfaces.md) (needs the trace context shape on `D3NexusLogger`/`ILogger`).

## References & Rollback
- **References**: [W3C Trace Context Specification](https://www.w3.org/TR/trace-context/).
- **Rollback Plan**: Remove the interceptor registration; the rest of the Dio client setup is unaffected since this is an additive interceptor, not a modification of existing ones.
