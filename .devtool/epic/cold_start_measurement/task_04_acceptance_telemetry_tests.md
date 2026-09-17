---
id: "task_04_acceptance_telemetry_tests"
status: "todo"
priority: "high"
assignee: null
epic: "cold_start_measurement"
dueDate: null
created: "2026-09-17T17:15:00+07:00"
modified: "2026-09-17T17:15:00+07:00"
completedAt: null
labels: ["acceptance", "integration", "testing"]
order: "a4"
---

# Task 04: Acceptance and Performance Integration Tests

## Context & Objectives
Implement end-to-end integration and acceptance tests verifying that the cold start telemetry suite reliably captures all startup milestones and initializers during host execution, generates a valid `ColdStartReport`, renders the ASCII report cleanly, and satisfies performance budget assertions without crashing or flakiness.

---

## BDD Acceptance Criteria

```gherkin
Feature: Cold Start Telemetry Acceptance Tests

  Scenario: Complete cold start telemetry run in test environment
    Given a fresh application launch using app.main
    When the application boots and mounts ShellPage
    Then ColdStartProfiler.instance.report should not be null
    And report.totalToFcp should be > 0 and < 3000 milliseconds
    And report.totalToTti should be >= report.totalToFcp
    And report.subInitializersDuration should contain all registered initializers
    And report.toFormattedAsciiTable() should contain "COLD START PERFORMANCE TELEMETRY REPORT"

  Scenario: Idempotent finish and stability across test suites
    Given ColdStartProfiler.instance has completed a startup run
    When finish or logReport are called again
    Then no exceptions or state corruptions should occur
    And calling start resets the telemetry state cleanly for the next run
```

---

## TDD Implementation Steps

### 1. QA Red Team (Test Authoring)
- Create `test/telemetry/cold_start_telemetry_acceptance_test.dart`.
- Write acceptance test scenarios covering:
  - Full startup lifecycle execution with `ColdStartProfiler`.
  - Verification of report contents (milestones, sub-initializers, durations).
  - Validation of ASCII formatting string.
  - Performance budget sanity checks.

### 2. TDD Master (Implementation)
- Implement necessary test harnesses, mocks, or resets in `ColdStartProfiler.reset()` to allow clean execution between multiple tests.
- Ensure integration tests in `integration_test/cold_start_performance_test.dart` continue to pass.

### 3. System Integration
- Run `fvm flutter test test/telemetry/cold_start_telemetry_acceptance_test.dart`.
- Run full test suite: `fvm flutter test` and `melos test`.
- Run `fvm flutter analyze`.
- Ensure zero errors and zero warnings.

---

## Definition of Done (DoD)
- [ ] End-to-end acceptance test passing 100%.
- [ ] Complete suite of host and core package tests passing without regressions.
- [ ] 0 analyze issues.
