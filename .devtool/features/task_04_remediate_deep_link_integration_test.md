---
id: "task_04_remediate_deep_link_integration_test"
status: "todo"
priority: "high"
assignee: null
epic: "test_suite_remediation"
dueDate: null
created: "2026-09-17T14:40:00Z"
modified: "2026-09-17T14:40:00Z"
completedAt: null
labels: ["testing", "integration", "deeplink"]
order: "a4"
---

# Task 04: Remediate Deep Link Integration Test for 3-Tab Shell

Epic: [test_suite_remediation](../epic/test_suite_remediation/test_suite_remediation.en.md)

## 1. Requirement Analysis
`integration_test/deep_link_flow_test.dart` currently implements manual platform mock setup and direct `app.main()` calls.
On `develop`, the active host shell consists of 3 tabs:
- Tab 0: `HomeDashboardPage`
- Tab 1: `ScannerPage`
- Tab 2: `SettingsPage`
This task refactors `deep_link_flow_test.dart` to:
- Use `IntegrationTestHelper.setupPlatformMocks()` and `IntegrationTestHelper.teardownPlatformMocks()`.
- Use `IntegrationTestHelper.launchApp(tester)`.
- Assert seamless navigation for:
  - `d3nexus://scanner` -> transitions to Tab 1 (`ScannerPage`).
  - `d3nexus://settings` -> transitions to Tab 2 (`SettingsPage`).
  - `d3nexus://unknown/path` -> falls back gracefully to Tab 0 (`HomeDashboardPage`).
- Maintain strict isolation from unmigrated 5-tab features (ensuring `WalletPage` is NOT referenced on `develop`).

## 2. Relevant Files & Context Pointers
- `integration_test/deep_link_flow_test.dart` (MODIFY)
- `integration_test/helpers/integration_test_helper.dart` (DEPENDENCY)
- `lib/shell/shell_page.dart` (REFERENCE)
- `lib/shell/home_dashboard_page.dart` (REFERENCE)

## 3. Design Rationale
- Using `IntegrationTestHelper` standardizes app bootstrapping.
- Preserving the 3-tab contracts on `develop` ensures deep link tests remain truthful to the codebase's current shipping state without pulling in premature features.

## 4. Impact Analysis & Blast Radius
- **Target Files & Symbols**: `deep_link_flow_test.dart`.
- **Downstream Callers**: Integration test suites.
- **Cross-Platform Bridges**: `AppLinks` event channels, `DeepLinkCoordinator`.
- **Target Test Coverage Threshold**: 100% pass rate.

## 5. BDD Scenarios & Acceptance Criteria

### BDD SCENARIOS

#### Scenario 1: Deep Link Navigation across 3-Tab Shell
- **Tags**: `[Tier C - Integration]`, `[HappyPath]`
- **Given** the app is launched on `ShellPage` via `IntegrationTestHelper.launchApp()`
- **When** `d3nexus://scanner` is dispatched
- **Then** the active tab switches to `ScannerPage` (tab 1)
- **When** `d3nexus://settings` is dispatched
- **Then** the active tab switches to `SettingsPage` (tab 2)
- **When** `d3nexus://unknown/path` is dispatched
- **Then** the active tab falls back to `HomeDashboardPage` (tab 0).

## 6. Test & Verification Checklist
- [ ] **RED**: Run `deep_link_flow_test.dart` to verify old mock setup overhead.
- [ ] **GREEN**: Refactor with `IntegrationTestHelper` and 3-tab assertions.
- [ ] **REFACTOR**: Ensure zero analyzer warnings with `fvm flutter analyze integration_test/`.
- [ ] **Tier C (Integration)**: Run on iOS Simulator with `--dart-define-from-file=secureFiles/stg/environment-configs.json` and verify test passes.

## 7. Definition of Done (DoD)
- `deep_link_flow_test.dart` cleanly uses `IntegrationTestHelper`.
- All deep link transitions pass against `develop`'s 3-tab shell.
- Zero dependencies on unmigrated modules (`wallet`, etc.).

## 8. Dependencies & Blockers
- Blocked by: [Task 01](task_01_create_staging_integration_test_helper.md).

## 9. References & Rollback
- Source Spec: [.devtool/epic/test_suite_remediation/2026-09-17-test-suite-remediation-design.md](../epic/test_suite_remediation/2026-09-17-test-suite-remediation-design.md)
- Rollback: Revert `integration_test/deep_link_flow_test.dart`.
