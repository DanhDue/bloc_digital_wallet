---
id: "task_04_scaffold_and_migrate_transaction_feature"
status: "done"
priority: "high"
assignee: null
epic: "super_app_features_migration"
dueDate: null
created: "2026-09-16T18:02:00+07:00"
modified: "2026-09-16T11:30:50Z"
completedAt: "2026-09-16T11:30:50Z"
labels: ["architecture", "transaction", "ledger"]
order: "a04"
---

# Task 04: Scaffold & Migrate Transaction Feature

Epic: [super_app_features_migration](../epic/super_app_features_migration/super_app_features_migration.en.md)

## Requirement Analysis
Create the autonomous mini-app `features/transaction` using Mason `pac_mvi_feature`. Port over the transaction ledger, categorized transaction history list, pagination, and transaction details screen from `danhdue/full_features:packages/transaction`. Upgrade to Freezed v3, Slang v4, and MVI architecture.

## Relevant Files & Context Pointers
- `bricks/pac_mvi_feature/`
- `features/transaction/pubspec.yaml`
- `features/transaction/slang.yaml`
- `features/transaction/lib/transaction.dart`
- `features/transaction/lib/transaction_router.dart`
- `features/transaction/lib/domain/usecases/get_transactions_usecase.dart`
- `features/transaction/lib/presentation/transaction/transaction_page.dart`
- `features/transaction/lib/presentation/transaction/bloc/transaction_bloc.dart`
- `features/transaction/test/presentation/transaction/transaction_bloc_test.dart`
- Source legacy reference: `danhdue/full_features:packages/transaction/`

## Design Rationale
- Scaffold package under `features/transaction` with Pub Workspace resolution.
- Ensure transaction states and models are immutable via Freezed v3.
- Export `TransactionRouter` with `TransactionRoute` and `TransactionDetailsRoute`.
- Implement unit tests for pagination, filtering, and transaction state handling.

## Impact Analysis & Blast Radius
- **Target Files & Symbols:** `TransactionPage`, `TransactionBloc`, `GetTransactionsUseCase`, `TransactionRepository`, `TransactionRouter`.
- **Downstream Callers:** Host `ShellPage` (Tab 1), Host `AppRouter`, `lib/di/injection.dart`.
- **Cross-Platform Bridges:** None.
- **Target Test Coverage Threshold:** $\ge 85\%$ for domain usecases and BLoCs.

## BDD Scenarios & Acceptance Criteria
### BDD SCENARIOS

```gherkin
Scenario: [Tier A - Unit] TransactionBloc loads initial page of transactions
  Given user opens transaction history
  When TransactionBloc processes started action
  Then state transitions: loading -> loaded(transactions: [...])

Scenario: [Tier A - Unit] Filter transactions by type
  Given TransactionBloc is loaded with transactions
  When filterChanged action with type "sent" is dispatched
  Then state filters list displaying only sent transactions

Scenario: [Tier A - Unit] Offline fallback serves cached transactions
  Given device is offline and network call fails
  When TransactionBloc fetches history
  Then state loads cached transactions from local storage with offline banner

Scenario: [Tier C - Integration] TransactionPage renders inside ShellPage Tab 1
  Given user switches to Tab 1 in ShellPage
  When Tab 1 is displayed
  Then TransactionPage renders ledger items with amounts and timestamps cleanly
```

## Test & Verification Checklist
- [ ] **RED**: Author failing unit tests for `TransactionBloc` and usecase.
- [ ] **GREEN**: Scaffold package via Mason, migrate data/domain/presentation logic, implement `TransactionBloc` and pass tests.
- [ ] **REFACTOR**: Check formatting (`melos format`), Slang generation, and ensure zero lint warnings.

## Definition of Done (DoD)
- `features/transaction` builds and passes all unit and widget tests.
- Pure domain usecases achieve $\ge 85\%$ line coverage.
- Boundaries check passes.

## Dependencies & Blockers
- Blocked by [Task 03](task_03_scaffold_and_migrate_wallet_feature.md).

## References & Rollback
- Source: `danhdue/full_features:packages/transaction`
- Rollback: `rm -rf features/transaction`
