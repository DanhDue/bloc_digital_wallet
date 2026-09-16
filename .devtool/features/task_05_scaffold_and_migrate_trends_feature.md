---
id: "task_05_scaffold_and_migrate_trends_feature"
status: "done"
priority: "high"
assignee: null
epic: "super_app_features_migration"
dueDate: null
created: "2026-09-16T18:02:00+07:00"
modified: "2026-09-16T11:34:46Z"
completedAt: "2026-09-16T11:34:46Z"
labels: ["architecture", "trends", "analytics"]
order: "a05"
---

# Task 05: Scaffold & Migrate Trends Feature

Epic: [super_app_features_migration](../epic/super_app_features_migration/super_app_features_migration.en.md)

## Requirement Analysis
Create the autonomous mini-app `features/trends` using Mason `pac_mvi_feature`. Port over the market analytics, crypto/fiat price trends, interactive charts, and timeframe selection from `danhdue/full_features:packages/trends`. Upgrade models to Freezed v3, Slang v4, and Clean Architecture MVI.

## Relevant Files & Context Pointers
- `bricks/pac_mvi_feature/`
- `features/trends/pubspec.yaml`
- `features/trends/slang.yaml`
- `features/trends/lib/trends.dart`
- `features/trends/lib/trends_router.dart`
- `features/trends/lib/domain/usecases/`
- `features/trends/lib/presentation/trends/trends_page.dart`
- `features/trends/lib/presentation/trends/trends_bloc.dart`
- `features/trends/test/presentation/trends/trends_bloc_test.dart`
- Source legacy reference: `danhdue/full_features:packages/trends/`

## Design Rationale
- Scaffold package under `features/trends` with Pub Workspace resolution.
- Keep chart data structures decoupled from presentation layer.
- Export `TrendsRouter` with `TrendsRoute`.
- Modernize Slang localization tokens under `assets/locales/`.

## Impact Analysis & Blast Radius
- **Target Files & Symbols:** `TrendsPage`, `TrendsBloc`, `TrendsRouter`.
- **Downstream Callers:** Host `ShellPage` (Tab 3), Host `AppRouter`, `lib/di/injection.dart`.
- **Cross-Platform Bridges:** None.
- **Target Test Coverage Threshold:** $\ge 85\%$ for domain usecases and BLoCs.

## BDD Scenarios & Acceptance Criteria
### BDD SCENARIOS

```gherkin
Scenario: [Tier A - Unit] TrendsBloc fetches market trend data
  Given user opens Trends tab
  When TrendsBloc processes started action
  Then state transitions: loading -> loaded(marketData: [...])

Scenario: [Tier A - Unit] Changing timeframe reloads chart points
  Given TrendsBloc is in loaded state
  When timeframeChanged action with timeframe "1M" is dispatched
  Then state transitions to chartLoading and resolves with 1M data points

Scenario: [Tier A - Unit] Rate limit 429 response handled gracefully
  Given market API responds with HTTP 429
  When TrendsBloc handles error
  Then state displays rate limit warning without crash

Scenario: [Tier C - Integration] TrendsPage renders inside ShellPage Tab 3
  Given user navigates to Tab 3 in ShellPage
  When Tab 3 is active
  Then TrendsPage displays price graphs and trending asset items
```

## Test & Verification Checklist
- [ ] **RED**: Author failing unit tests for `TrendsBloc`.
- [ ] **GREEN**: Scaffold package via Mason, migrate models/datasources/usecases/pages, satisfy all unit tests.
- [ ] **REFACTOR**: Check formatting (`melos format`), Slang generation, and ensure zero lint warnings.

## Definition of Done (DoD)
- `features/trends` compiles and passes all unit and widget tests.
- Pure domain usecases achieve $\ge 85\%$ line coverage.
- Boundaries check passes.

## Dependencies & Blockers
- Blocked by [Task 04](task_04_scaffold_and_migrate_transaction_feature.md).

## References & Rollback
- Source: `danhdue/full_features:packages/trends`
- Rollback: `rm -rf features/trends`
