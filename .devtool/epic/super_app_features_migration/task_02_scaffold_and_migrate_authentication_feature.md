---
id: "task_02_scaffold_and_migrate_authentication_feature"
status: "done"
priority: "high"
assignee: null
epic: "super_app_features_migration"
dueDate: null
created: "2026-09-16T18:02:00+07:00"
modified: "2026-09-16T11:23:59Z"
completedAt: "2026-09-16T11:23:59Z"
labels: ["architecture", "authentication", "security"]
order: "a02"
---

# Task 02: Scaffold & Migrate Authentication Feature

Epic: [super_app_features_migration](super_app_features_migration.en.md)

## Requirement Analysis
Create the autonomous mini-app `features/authentication` using Mason `pac_mvi_feature`. Port over the login user flow, credential validation, LoginBloc, LoginUseCase, token interceptor, and secure storage integration from `danhdue/full_features:packages/authentication`.

## Relevant Files & Context Pointers
- `bricks/pac_mvi_feature/`
- `features/authentication/pubspec.yaml`
- `features/authentication/slang.yaml`
- `features/authentication/lib/authentication.dart`
- `features/authentication/lib/authentication_router.dart`
- `features/authentication/lib/domain/usecases/login_usecase.dart`
- `features/authentication/lib/presentation/login/login_page.dart`
- `features/authentication/lib/presentation/login/login_bloc.dart`
- `features/authentication/test/presentation/login/login_bloc_test.dart`
- Source legacy reference: `danhdue/full_features:packages/authentication/`

## Design Rationale
- Scaffold package under `features/authentication` with Pub Workspace resolution.
- Keep domain usecases strictly pure and testable with mocktail.
- Integrate token persistence cleanly and export `AuthenticationRouter` for `LoginRoute`.
- Modernize Slang localization tokens under `assets/locales/`.

## Impact Analysis & Blast Radius
- **Target Files & Symbols:** `LoginPage`, `LoginBloc`, `LoginUseCase`, `AuthenticationRepository`, `AuthenticationRouter`.
- **Downstream Callers:** Host `AppRouter` (`lib/app_router.dart`), `lib/di/injection.dart`.
- **Cross-Platform Bridges:** None.
- **Target Test Coverage Threshold:** $\ge 85\%$ for `LoginUseCase` and `LoginBloc`, 100% for token storage handling.

## BDD Scenarios & Acceptance Criteria
### BDD SCENARIOS

```gherkin
Scenario: [Tier A - Unit] User submits valid credentials and succeeds
  Given valid username "test@wallet.com" and password "Pass123!"
  When LoginBloc processes loginSubmitted action
  Then state transitions: idle -> loading -> success
  And auth token is stored in secure storage
  And loginSuccess event is dispatched

Scenario: [Tier A - Unit] Submission with empty fields triggers validation error
  Given empty email or empty password
  When loginSubmitted action is dispatched
  Then state transitions to validationError without calling LoginUseCase

Scenario: [Tier A - Unit] Login failure handles 401 unauthorized
  Given remote service returns 401 Unauthorized
  When LoginBloc processes response
  Then state transitions to failure with localized error message
  And entered username remains in state

Scenario: [Tier C - Integration] Successful login routes to Super App Shell
  Given user is on LoginPage
  When valid login finishes successfully
  Then router navigates to ShellRoute (/home)
```

## Test & Verification Checklist
- [ ] **RED**: Author failing unit tests for `LoginBloc` and `LoginUseCase` covering all scenarios.
- [ ] **GREEN**: Scaffold package via Mason, migrate data/domain/presentation logic, implement `LoginBloc` and pass tests.
- [ ] **REFACTOR**: Check formatting (`melos format`), Slang generation, and ensure zero lint warnings.

## Definition of Done (DoD)
- `features/authentication` builds cleanly under Pub Workspace.
- Unit and widget tests pass 100% with $\ge 85\%$ line coverage.
- Module boundary check passes.

## Dependencies & Blockers
- Blocked by [Task 01](task_01_scaffold_and_migrate_onboard_feature.md).

## References & Rollback
- Source: `danhdue/full_features:packages/authentication`
- Rollback: `rm -rf features/authentication`
