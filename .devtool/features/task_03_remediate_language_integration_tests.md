---
id: "task_03_remediate_language_integration_tests"
status: "todo"
priority: "high"
assignee: null
epic: "test_suite_remediation"
dueDate: null
created: "2026-09-17T14:40:00Z"
modified: "2026-09-17T14:40:00Z"
completedAt: null
labels: ["testing", "integration", "localization"]
order: "a3"
---

# Task 03: Remediate Language Integration Tests

Epic: [test_suite_remediation](../epic/test_suite_remediation/test_suite_remediation.en.md)

## 1. Requirement Analysis
Integration tests for language switching on Staging currently suffer from timing flakiness and race conditions:
1. `change_language_test.dart`:
   - Use of arbitrary delays (`humanDelay(1200)`) causes flaky assertions on `CustomLoadingWidget`.
   - Must advance to frame where loading dialog is mounted (`pump(Duration(milliseconds: 100))`) before asserting its presence.
   - Use `IntegrationTestHelper.launchApp(tester)`.
2. `language_edge_cases_test.dart`:
   - Lacks platform mocks setup and teardown, causing channel communication noise.
   - **Edge Case 2 (Network Error SnackBar)**: `waitForLoadingToDisappear` calls `pumpAndSettle()`, which dismisses the error `SnackBar` prematurely before `expect(find.byType(SnackBar))` can find it. Must replace with active polling that verifies `CustomLoadingWidget` dismissal without `pumpAndSettle`, followed by `pumpUntil(find.byType(SnackBar))`.
   - **Edge Case 4 (Cold-Start Persistence)**: `pumpAndSettle(Duration(seconds: 5))` stalls on looping Lottie splash animations. Must replace with stepped frame pump loop (`15 * 300ms`) and `IntegrationTestHelper.switchTab`.

## 2. Relevant Files & Context Pointers
- `integration_test/change_language_test.dart` (MODIFY)
- `integration_test/language_edge_cases_test.dart` (MODIFY)
- `integration_test/helpers/integration_test_helper.dart` (DEPENDENCY)
- `integration_test/helpers/language_test_helper.dart` (DEPENDENCY)

## 3. Design Rationale
- Replacing `pumpAndSettle` with targeted polling prevents premature toast dismissal and animation deadlocks while preserving realistic user interaction cadence.

## 4. Impact Analysis & Blast Radius
- **Target Files & Symbols**: `change_language_test.dart`, `language_edge_cases_test.dart`.
- **Downstream Callers**: CI Integration Test runner, developer test suite.
- **Cross-Platform Bridges**: None.
- **Target Test Coverage Threshold**: 100% pass on all 4 standard use cases and 4 edge cases.

## 5. BDD Scenarios & Acceptance Criteria

### BDD SCENARIOS

#### Scenario 1: Live OTA Translation Download and UI Update for Japanese on Staging
- **Tags**: `[Tier C - Integration]`, `[HappyPath]`
- **Given** the app is launched on Staging (`--dart-define-from-file=secureFiles/stg/environment-configs.json`)
- **When** the user selects Japanese in `change_language_test.dart`
- **Then** `CustomLoadingWidget` is mounted and verified with `pump(100ms)`
- **And** the download finishes and Settings page UI displays Japanese text.

#### Scenario 2: Error SnackBar Display Persistence Without Premature Dismissal
- **Tags**: `[Tier C - Integration]`, `[AsyncRace]`
- **Given** a translation download network failure occurs in Edge Case 2
- **When** `CustomLoadingWidget` dismisses
- **Then** the test framework does not call `pumpAndSettle()`
- **And** `pumpUntil(find.byType(SnackBar))` finds the error toast on screen.

#### Scenario 3: Cold-Start Language Restoration from SharedPreferences
- **Tags**: `[Tier C - Integration]`, `[EdgeCase]`
- **Given** `saved_language_code = 'ja_JP'` is seeded in `SharedPreferences`
- **When** the app is cold-started in Edge Case 4
- **Then** frames pump across Splash without hanging on Lottie animations
- **And** Japanese locale is verified on `SettingsPage`.

## 6. Test & Verification Checklist
- [ ] **RED**: Confirm that Edge Case 2 fails or flakes when `waitForLoadingToDisappear` dismisses SnackBar.
- [ ] **GREEN**: Apply fixes to `change_language_test.dart` and `language_edge_cases_test.dart`.
- [ ] **REFACTOR**: Format and analyze with `fvm flutter analyze integration_test/`.
- [ ] **Tier C (Integration)**: Execute both suites on iOS Simulator with `--dart-define-from-file=secureFiles/stg/environment-configs.json` and verify 100% pass.

## 7. Definition of Done (DoD)
- Both integration test suites run cleanly on Staging with zero flakiness.
- All 8 scenarios pass reliably on simulator.

## 8. Dependencies & Blockers
- Blocked by: [Task 01](task_01_create_staging_integration_test_helper.md).

## 9. References & Rollback
- Source Spec: [.devtool/epic/test_suite_remediation/2026-09-17-test-suite-remediation-design.md](../epic/test_suite_remediation/2026-09-17-test-suite-remediation-design.md)
- Rollback: Revert `integration_test/change_language_test.dart` and `integration_test/language_edge_cases_test.dart`.
