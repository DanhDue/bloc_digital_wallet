---
id: "task_04_integration_and_quality_gate"
status: "done"
priority: "high"
assignee: null
epic: "system_theme_sync"
dueDate: null
created: "2026-09-17T22:25:00+07:00"
modified: "2026-09-17T15:38:46Z"
completedAt: "2026-09-17T15:38:46Z"
labels: ["integration", "quality_check", "3-tier", "governance"]
order: "a4"
---

# Task 04: Host App Integration, BDD Acceptance & 3-Tier Quality Gate

## Context & Objectives
Execute the end-to-end integration and master governance quality gate for the `system_theme_sync` epic:
1. Verify `lib/main.dart` and the host application correctly consume `ThemeManager.instance.themeModeStream`.
2. Verify Settings screen and shell integration under both system mode and explicit user preferences.
3. Run the comprehensive 3-Tier quality suite (`melos test`, `melos analyze`, `./scripts/check_module_boundaries.sh`, `./scripts/check_license_header.sh`).
4. Ensure 0 errors, 0 warnings, and produce the final Executive Quality Report.

---

## BDD Acceptance Criteria

```gherkin
Feature: Epic Integration & Governance Quality Gate

  Scenario: Root composition correctly updates themeMode on stream event
    Given the root MaterialApp.router mounted in lib/main.dart
    When ThemeManager.instance.setThemeMode(ThemeMode.dark) is called
    Then the root MaterialApp rebuilds with ThemeMode.dark

  Scenario: Master 3-Tier test suite passes cleanly
    Given all epic changes across core, settings, native_security, and network
    When melos test is executed across all packages
    Then all package tests pass with 100% success rate

  Scenario: Static analysis and architecture boundaries pass with zero defects
    Given the modified workspace
    When melos analyze and check_module_boundaries.sh are executed
    Then zero errors and zero warnings are reported
```

---

## TDD Implementation Steps

### 1. QA Red Team (Test Authoring)
- Run `test/root_composition_test.dart` to verify `ThemeManager` stream updates `MaterialApp` themeMode.
- Verify `test/di/injection_test.dart` passes.

### 2. TDD Master (Implementation)
- Resolve any integration friction or contract mismatches discovered during end-to-end wiring.
- Ensure all imports adhere to Clean Architecture boundaries (`Presentation -> Domain <- Data`).

### 3. System Integration & Verification
- Run `fvm flutter test test/root_composition_test.dart`.
- Run `./scripts/check_module_boundaries.sh`.
- Run `./scripts/check_license_header.sh`.
- Run `melos analyze` across the entire workspace.
- Execute `@quality_check` master gate.

---

## Definition of Done (DoD)
- [ ] Root application correctly integrates with `ThemeManager` without Frame-0 latency.
- [ ] Tier A, B, and C tests pass.
- [ ] Architecture boundaries verified cleanly.
- [ ] Unified Executive Quality Report generated with 🟢 LGTM verdict.
