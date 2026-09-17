---
id: "task_01_scaffold_and_migrate_onboard_feature"
status: "done"
priority: "high"
assignee: null
epic: "super_app_features_migration"
dueDate: null
created: "2026-09-16T18:02:00+07:00"
modified: "2026-09-16T11:17:16Z"
completedAt: "2026-09-16T11:17:16Z"
labels: ["architecture", "onboard", "scaffolding"]
order: "a01"
---

# Task 01: Scaffold & Migrate Onboard Feature

Epic: [super_app_features_migration](super_app_features_migration.en.md)

## Requirement Analysis
Create the autonomous mini-app `features/onboard` following Clean Architecture and MVI using the Mason brick `pac_mvi_feature`. Port over the application launch, splash screen, and initialization flow from `danhdue/full_features:packages/onboard`, upgrading it to Slang v4 and Flutter Pub Workspace standards.

## Relevant Files & Context Pointers
- `bricks/pac_mvi_feature/` (Scaffolding brick)
- `features/onboard/pubspec.yaml`
- `features/onboard/slang.yaml`
- `features/onboard/lib/onboard.dart`
- `features/onboard/lib/onboard_router.dart`
- `features/onboard/lib/presentation/splash/splash_page.dart`
- `features/onboard/lib/presentation/splash/splash_bloc.dart`
- `features/onboard/test/presentation/splash/splash_bloc_test.dart`
- Source legacy reference: `danhdue/full_features:packages/onboard/`

## Design Rationale
- Use `mason make pac_mvi_feature --name onboard -o features` to generate the package skeleton.
- Migrate MVI components inheriting from `BaseMviPage` and `BaseBloc` in `packages/framework`.
- Export `OnboardRouter` with `SplashRoute` to decouple routing from the host app.
- Provide Slang v4 JSON files in `assets/locales/` for splash copy.

## Impact Analysis & Blast Radius
- **Target Files & Symbols:** `SplashPage`, `SplashBloc`, `SplashAction`, `SplashState`, `SplashEvent`, `OnboardRouter`.
- **Downstream Callers:** Host `AppRouter` (`lib/app_router.dart`), Host `configureDependencies` (`lib/di/injection.dart`).
- **Cross-Platform Bridges:** None.
- **Target Test Coverage Threshold:** $\ge 85\%$ line coverage on `SplashBloc` and domain logic.

## BDD Scenarios & Acceptance Criteria
### BDD SCENARIOS

```gherkin
Scenario: [Tier A - Unit] SplashBloc processes started action and emits loading
  Given a fresh SplashBloc
  When started action is dispatched
  Then it emits SplashState.loading
  And after splash delay timer it emits navigation ready event

Scenario: [Tier A - Unit] Rapid consecutive start actions are deduplicated
  Given SplashBloc is already running timer
  When another started action is dispatched immediately
  Then duplicate timers are ignored and single navigation event is emitted

Scenario: [Tier A - Unit] SplashBloc handles corrupted session storage gracefully
  Given local storage read fails with an exception
  When started action is processed
  Then SplashBloc catches exception and emits navigateToLogin event

Scenario: [Tier C - Integration] Host router loads SplashRoute as initial route
  Given app starts cold
  When router evaluates initial path
  Then SplashPage is rendered at path "/splash"
```

## Test & Verification Checklist
- [ ] **RED**: Author failing unit test in `features/onboard/test/presentation/splash/splash_bloc_test.dart` for all `[Tier A - Unit]` scenarios.
- [ ] **GREEN**: Run Mason generator `pac_mvi_feature`, migrate logic from `danhdue/full_features:packages/onboard`, implement `SplashBloc` and `SplashPage` until tests pass.
- [ ] **REFACTOR**: Ensure Slang v4 codegen runs cleanly, format code (`melos format`), and verify `fvm flutter test` in `features/onboard`.

## Definition of Done (DoD)
- `features/onboard` exists and is a valid Pub Workspace member.
- Unit and widget tests pass 100% with $\ge 85\%$ line coverage.
- Slang v4 and AutoRoute generator generate code cleanly.

## Dependencies & Blockers
- None (First task in sequence).

## References & Rollback
- Source: `danhdue/full_features:packages/onboard`
- Rollback: `rm -rf features/onboard` and revert workspace changes.
