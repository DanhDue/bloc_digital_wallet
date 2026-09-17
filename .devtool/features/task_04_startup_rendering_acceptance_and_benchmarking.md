---
id: "task_04_startup_rendering_acceptance_and_benchmarking"
status: "todo"
priority: "high"
assignee: null
epic: "startup_rendering_optimization"
dueDate: null
created: "2026-09-17T18:00:00+07:00"
modified: "2026-09-17T18:00:00+07:00"
completedAt: null
labels: ["acceptance", "performance", "telemetry", "benchmarking"]
order: "a4"
---

# Task 04: Acceptance Telemetry & Performance Benchmarking

## Context & Objectives
Execute end-to-end integration and acceptance tests verifying that the startup rendering optimizations satisfy the performance budget (`ColdStartReport.totalToFcp < 280ms`, `widgetTreeDuration < 200ms`), pass all 3 testing tiers of `@quality_check`, and successfully compile and execute on a physical device / simulator.

---

## BDD Acceptance Criteria

```gherkin
Feature: Performance Telemetry Verification

  Scenario: Cold start FCP budget satisfaction
    Given the application launches on a device or simulator
    When ShellPage post-frame callback fires
    Then ColdStartReport.totalToFcp should be strictly less than 280 milliseconds
    And ColdStartReport.widgetTreeDuration should be strictly less than 200 milliseconds
    And ColdStartProfiler should output the structured ASCII report to Talker

  Scenario: Full Quality Check Gate (Tier A, Tier B, Tier C)
    Given all implementation tasks are completed
    When quality_check is executed
    Then all unit, widget, and integration tests must pass 100%
    And flutter analyze must report 0 errors and 0 warnings
    And module boundaries and license headers must be 100% compliant
    And clean, native build smoke test, and simulator run must succeed
```

---

## TDD Implementation Steps

### 1. QA Red Team (Test Authoring)
- Update `test/telemetry/cold_start_telemetry_acceptance_test.dart`:
  - Assert that `report.totalToFcp` and `report.totalToTti` satisfy the optimized budget.
  - Verify that `SettingsPage` Frame-0 renders with success status.
  - Verify ASCII report formatting includes all phases.

### 2. TDD Master (Implementation)
- Ensure all optimizations across `LazyIndexedStack`, `SettingsBloc`, and `ShellPage` are cohesive and resilient.
- Run `fvm flutter test test/telemetry/cold_start_telemetry_acceptance_test.dart`.

### 3. System Integration & Verification
- Execute full 3-Tier suite via `quality_check`:
  - `fvm flutter test` (all packages)
  - `fvm flutter analyze`
  - `./scripts/check_module_boundaries.sh`
  - `./scripts/check_license_header.sh`
  - `fvm flutter clean && fvm flutter pub get`
  - Native build smoke test (`fvm flutter build ios --simulator --flavor dev ...` or apk)
  - Simulator runtime verification.

---

## Definition of Done (DoD)
- [ ] Acceptance test passes 100%.
- [ ] 0 analyzer issues across the monorepo.
- [ ] Verified reduction in cold start duration on simulator.
- [ ] Clean, build, and run smoke tests succeed.
