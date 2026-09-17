---
id: "task_01_core_cold_start_profiler"
status: "done"
priority: "high"
assignee: null
epic: "cold_start_measurement"
dueDate: null
created: "2026-09-17T17:15:00+07:00"
modified: "2026-09-17T10:32:22Z"
completedAt: "2026-09-17T10:32:22Z"
labels: ["telemetry", "profiling", "core"]
order: "a1"
---

# Task 01: Core ColdStartProfiler & ColdStartReport Engine in packages/core

## Context & Objectives
Build a high-precision, decoupled cold-start profiling and telemetry engine in `packages/core/lib/telemetry/`. The profiler must measure startup timestamps using `Stopwatch` / microsecond clocks, integrate with `dart:developer.TimelineTask` for DevTools performance visual traces, provide `timeSync` and `timeAsync` execution wrappers, and generate formatted ASCII reports.

---

## BDD Acceptance Criteria

```gherkin
Feature: Core ColdStartProfiler Engine

  Scenario: Record milestones in chronological order
    Given ColdStartProfiler is instantiated and enabled
    When start is invoked at T0
    And mark is called for bindingInitialized, diReady, and firstFrameRendered
    Then report should contain non-negative elapsed durations for each milestone
    And totalToFcp should equal the duration from start to firstFrameRendered

  Scenario: Measure synchronous and asynchronous execution blocks
    Given ColdStartProfiler is enabled
    When timeSync is called with a synchronous task taking 10ms
    And timeAsync is called with an asynchronous task taking 20ms
    Then both tasks should complete and return their expected values
    And the recorded durations for both tasks should be >= 10ms and >= 20ms respectively

  Scenario: Formatted ASCII table generation
    Given a completed ColdStartReport with multiple milestone entries
    When toFormattedAsciiTable is called
    Then the output should contain table borders, milestone names, millisecond durations, and percentage breakdown
```

---

## TDD Implementation Steps

### 1. QA Red Team (Test Authoring)
- Create `packages/core/test/telemetry/cold_start_profiler_test.dart`.
- Write failing unit tests verifying:
  - Timestamp recording and chronological order.
  - Calculation of `totalToFcp`, `totalToTti`, and sub-initializer phase durations.
  - `timeSync` and `timeAsync` accuracy and error resilience.
  - Toggle / disabled behavior (returns result without tracking, zero exceptions).
  - ASCII report output formatting.

### 2. TDD Master (Implementation)
- Create `packages/core/lib/telemetry/cold_start_milestone.dart`:
  - Enum `ColdStartMilestone` (`mainEntry`, `bindingInitialized`, `diStarted`, `diReady`, `coreServicesStarted`, `coreServicesReady`, `runAppInvoked`, `firstFrameRendered`, `firstScreenInteractive`).
- Create `packages/core/lib/telemetry/cold_start_report.dart`:
  - Class `MilestoneRecord` and `ColdStartReport` with duration getters and `toFormattedAsciiTable()`.
- Create `packages/core/lib/telemetry/cold_start_profiler.dart`:
  - Singleton `ColdStartProfiler` supporting `start()`, `mark()`, `timeSync()`, `timeAsync()`, `finish()`, `report`, and `logReport()`.
- Export telemetry models in `packages/core/lib/core.dart`.

### 3. System Integration
- Run `fvm flutter test packages/core/test/telemetry/cold_start_profiler_test.dart` and `fvm flutter analyze packages/core`.
- Ensure 100% test pass rate with 0 linter warnings.

---

## Definition of Done (DoD)
- [ ] Unit test suite passing with >= 85% line coverage.
- [ ] DevTools Timeline events properly wrapped without uncaught errors.
- [ ] Clean zero-cost execution when `enabled == false`.
- [ ] Formatted ASCII summary table ready for console/Talker logging.
