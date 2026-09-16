---
id: "task_07_host_acceptance_tests_and_quality_check"
status: "done"
priority: "high"
assignee: null
epic: "super_app_features_migration"
dueDate: null
created: "2026-09-16T18:02:00+07:00"
modified: "2026-09-16T11:44:55Z"
completedAt: "2026-09-16T11:44:55Z"
labels: ["qa", "acceptance", "quality-check"]
order: "a07"
---

# Task 07: Host Acceptance Tests & Quality Check

Epic: [super_app_features_migration](../epic/super_app_features_migration/super_app_features_migration.en.md)

## Requirement Analysis
Execute full acceptance testing and quality verification for the migrated Super App. Update host unit and integration tests (`integration_test/deep_link_flow_test.dart`, `test/shell/`, `test/router/`, `test/di/`), verify module boundaries via `./scripts/check_module_boundaries.sh`, run static analyzer (`melos analyze`), execute the 3-Tier test suite via `./scripts/testWithCoverage.sh`, and run the master `@quality_check` workflow to achieve 🟢 LGTM for Gate 4 and prepare for Gate 5 Developer Kanban Review.

## Relevant Files & Context Pointers
- `integration_test/deep_link_flow_test.dart`
- `test/router/app_router_mode_test.dart`
- `test/shell/shell_mode_test.dart`
- `test/shell/shell_page_deeplink_test.dart`
- `test/di/injection_test.dart`
- `scripts/check_module_boundaries.sh`
- `scripts/testWithCoverage.sh`
- `scripts/genAlls.sh`

## Design Rationale
- Ensure all downstream callers identified during Shift-Left Impact Analysis (`check_code_impact.py`) are fully updated and tested.
- Verify that every mini-app boundary is respected (zero illicit cross-imports between features).
- Confirm that all 5 bottom tabs are navigable and that `MiniAppErrorBoundary` handles unhandled exceptions without app termination.
- Complete Gate 4 with `@quality_check` and hold tasks in `done/` for Gate 5 sign-off.

## Impact Analysis & Blast Radius
- **Target Files & Symbols:** Host test suites across `test/` and `integration_test/`.
- **Downstream Callers:** Entire test suite and CI pipeline.
- **Cross-Platform Bridges:** Native security / bridge verification.
- **Target Test Coverage Threshold:** $\ge 85\%$ overall domain logic coverage.

## BDD Scenarios & Acceptance Criteria
### BDD SCENARIOS

```gherkin
Scenario: [Tier C - Integration] Complete end-to-end user navigation flow
  Given the user starts on SplashPage
  When splash delay completes
  Then user is routed to LoginPage or ShellPage based on auth token
  When in ShellPage, user can switch across all 5 tabs (Wallet, Transaction, Scanner, Trends, Settings)
  And each tab renders its corresponding mini-app dashboard cleanly

Scenario: [Tier C - Integration] DeepLink routing to feature sub-page
  Given the app is running in background
  When a deep link is received for transaction details
  Then DeepLinkCoordinator navigates to Transaction tab and displays TransactionDetailsRoute

Scenario: [Tier B - Governance] Architecture boundary compliance
  Given all packages and features in workspace
  When ./scripts/check_module_boundaries.sh is executed
  Then zero illegal feature-to-feature dependencies are reported
```

## Test & Verification Checklist
- [ ] **RED**: Run existing integration and host unit tests to verify any failures due to modified tab count or routes.
- [ ] **GREEN**: Update test expectations, mock registrations in `test/di/injection_test.dart`, and make all tests pass cleanly.
- [ ] **REFACTOR & AUDIT**:
  - Run `./scripts/check_module_boundaries.sh` to confirm zero violations.
  - Run `melos analyze` to confirm zero static analyzer warnings.
  - Run `./scripts/testWithCoverage.sh` to confirm 100% test pass rate.
  - Run `@quality_check` skill to obtain 🟢 LGTM verdict across Security, Architecture, UI, and Code Health audits (Gate 4).

## Definition of Done (DoD)
- 100% test pass rate across all unit, widget, and integration tests.
- Zero static analysis or linter issues.
- `@quality_check` reports 🟢 LGTM (Gate 4).
- Ready for developer Kanban review and user sign-off (Gate 5).

## Dependencies & Blockers
- Blocked by [Task 06](task_06_host_app_shell_navigation_di_integration.md).

## References & Rollback
- Scripts: `scripts/check_module_boundaries.sh`, `scripts/testWithCoverage.sh`
- Rollback: Revert failing test changes.
