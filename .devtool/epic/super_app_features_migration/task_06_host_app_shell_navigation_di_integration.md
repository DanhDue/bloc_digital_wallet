---
id: "task_06_host_app_shell_navigation_di_integration"
status: "todo"
priority: "high"
assignee: null
epic: "super_app_features_migration"
dueDate: null
created: "2026-09-16T18:02:00+07:00"
modified: "2026-09-16T18:02:00+07:00"
completedAt: null
labels: ["architecture", "shell", "integration"]
order: "a06"
---

# Task 06: Host App Shell, Navigation & DI Integration

Epic: [super_app_features_migration](../epic/super_app_features_migration/super_app_features_migration.en.md)

## Requirement Analysis
Integrate the 5 migrated features (`onboard`, `authentication`, `wallet`, `transaction`, `trends`) into the Super App Host (`lib/`). Update the root `pubspec.yaml` workspace, configure 5 tabs in `ShellPage` wrapped in `MiniAppErrorBoundary`, update `CustomBottomNavBar` and `ShellConfig`, wire up all sub-routers in `AppRouter`, update DI in `lib/di/injection.dart`, remove obsolete empty package directories from `packages/`, and run `melos genAlls`.

## Relevant Files & Context Pointers
- `pubspec.yaml` (Root pubspec workspace)
- `lib/app_router.dart`
- `lib/app_router.gr.dart`
- `lib/di/injection.dart`
- `lib/di/injection.config.dart`
- `lib/shell/shell_page.dart`
- `lib/shell/shell_config.dart`
- `lib/shell/widgets/custom_bottom_nav_bar.dart`
- Obsolete cleanup paths: `packages/authentication/`, `packages/onboard/`, `packages/wallet/`, `packages/transaction/`, `packages/trends/`, `packages/home/`

## Design Rationale
- Update `pubspec.yaml` to declare all 5 feature mini-apps under `workspace:`.
- In `lib/shell/shell_page.dart`, wrap all 5 tabs in `MiniAppErrorBoundary(moduleName: '...', child: ...)`.
- Update `ShellConfig`: `tabCount = 5`, `defaultTabIndex = 0`, `hasScannerTab = true`.
- In `lib/app_router.dart`, mount `SplashRoute` (initial: true), `_authRouter.routes`, `ShellRoute`, and sub-feature routes.
- In `lib/di/injection.dart`, invoke `configureModuleDependencies(getIt)` for all 5 features before `$initGetIt()`.
- Run `melos genAlls` to synchronize all generated code.

## Impact Analysis & Blast Radius
- **Target Files & Symbols:** `AppRouter`, `ShellPage`, `ShellConfig`, `CustomBottomNavBar`, `configureDependencies`.
- **Downstream Callers:** 18 downstream callers (analyzed via `check_code_impact.py`), including `test/di/injection_test.dart`, `test/shell/shell_page_deeplink_test.dart`.
- **Cross-Platform Bridges:** None.
- **Target Test Coverage Threshold:** $\ge 80\%$ on ShellPage and AppRouter.

## BDD Scenarios & Acceptance Criteria
### BDD SCENARIOS

```gherkin
Scenario: [Tier C - Integration] ShellPage hosts 5 tabs with MiniAppErrorBoundary
  Given user is authenticated
  When ShellPage loads
  Then 5 tabs (Wallet, Transaction, Scanner, Trends, Settings) are mounted
  And each tab is protected by MiniAppErrorBoundary

Scenario: [Tier A - Unit] ShellConfig specifies 5 tabs and default tab 0
  Given ShellConfig
  When tabCount is queried
  Then it equals 5
  And defaultTabIndex equals 0

Scenario: [Tier C - Integration] Full App Router traversal
  Given app starts at /splash
  When session check completes unauthenticated
  Then router pushes /login
  When login succeeds
  Then router pushes /home (ShellPage)
```

## Test & Verification Checklist
- [ ] **RED**: Update `test/shell/shell_mode_test.dart` and `test/router/app_router_mode_test.dart` to assert 5 tabs and fail against current 3-tab config.
- [ ] **GREEN**: Wire up `ShellPage`, `ShellConfig`, `CustomBottomNavBar`, `AppRouter`, and `injection.dart`. Remove legacy empty folders from `packages/`. Run `melos genAlls` until tests pass.
- [ ] **REFACTOR**: Check formatting (`melos format`), license headers, and verify clean analyzer report (`melos analyze`).

## Definition of Done (DoD)
- All 5 features registered and functioning in Host Shell.
- Zero leftover empty folders in `packages/`.
- `melos genAlls` completes with zero errors.

## Dependencies & Blockers
- Blocked by [Task 01](task_01_scaffold_and_migrate_onboard_feature.md), [Task 02](task_02_scaffold_and_migrate_authentication_feature.md), [Task 03](task_03_scaffold_and_migrate_wallet_feature.md), [Task 04](task_04_scaffold_and_migrate_transaction_feature.md), [Task 05](task_05_scaffold_and_migrate_trends_feature.md).

## References & Rollback
- Source: `danhdue/full_features:lib/`
- Rollback: `git checkout HEAD -- lib/ pubspec.yaml`
