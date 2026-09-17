---
id: "task_02_sub_initializers_benchmarking"
status: "done"
priority: "high"
assignee: null
epic: "cold_start_measurement"
dueDate: null
created: "2026-09-17T17:15:00+07:00"
modified: "2026-09-17T10:33:27Z"
completedAt: "2026-09-17T10:33:27Z"
labels: ["telemetry", "initializers", "benchmarking"]
order: "a2"
---

# Task 02: Micro-Benchmarking for AppInitializerImpl in packages/core

## Context & Objectives
In `packages/core/lib/app_initializer/app_initializer_impl.dart`, multiple `AppInitializer` instances run concurrently via `Future.wait`. Developers need to know exactly how much time each individual sub-initializer takes (e.g. `LoggingInitializer`, `LocalizationInitializer`, `ImageCacheInitializer`, etc.) to find startup bottlenecks without breaking the failure-isolation principle.

---

## BDD Acceptance Criteria

```gherkin
Feature: Sub-Initializer Micro-Benchmarking

  Scenario: Measure individual sub-initializer durations
    Given AppInitializerImpl has 3 registered initializers: A, B, and C
    When init is invoked
    Then ColdStartProfiler should record named entries for A, B, and C
    And all 3 entries should have recorded durations >= 0 milliseconds

  Scenario: Maintain error isolation during profiling
    Given initializer B throws an exception during init
    When AppInitializerImpl.init executes
    Then the exception should be caught and not propagate to abort sibling initializers
    And initializer B should still record its elapsed time up to the failure point
    And initializers A and C should complete and record normally
```

---

## TDD Implementation Steps

### 1. QA Red Team (Test Authoring)
- Update `test/core/app_initializer/app_initializer_impl_test.dart` (and add telemetry assertions).
- Add tests verifying:
  - Each initializer execution calls `ColdStartProfiler.instance.timeAsync` with the initializer's name/class.
  - Failing initializers do not crash `AppInitializerImpl` and still finish their profiler time window.

### 2. TDD Master (Implementation)
- Modify `packages/core/lib/app_initializer/app_initializer_impl.dart`:
  - Wrap `initializer.init()` with `ColdStartProfiler.instance.timeAsync(initializer.runtimeType.toString(), () => initializer.init())`.
  - Preserve `catchError((_) {})` error isolation so failures in one initializer never prevent siblings from completing.

### 3. System Integration
- Run `fvm flutter test test/core/app_initializer/app_initializer_impl_test.dart`.
- Run `fvm flutter analyze packages/core`.
- Ensure 100% test pass rate with 0 linter warnings.

---

## Definition of Done (DoD)
- [ ] Individual sub-initializer execution times tracked in `ColdStartProfiler`.
- [ ] Error isolation intact (failures do not propagate).
- [ ] Unit tests passing with >= 85% coverage on modified lines.
