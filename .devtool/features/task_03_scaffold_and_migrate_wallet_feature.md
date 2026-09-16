---
id: "task_03_scaffold_and_migrate_wallet_feature"
status: "todo"
priority: "high"
assignee: null
epic: "super_app_features_migration"
dueDate: null
created: "2026-09-16T18:02:00+07:00"
modified: "2026-09-16T18:02:00+07:00"
completedAt: null
labels: ["architecture", "wallet", "financial"]
order: "a03"
---

# Task 03: Scaffold & Migrate Wallet Feature

Epic: [super_app_features_migration](../epic/super_app_features_migration/super_app_features_migration.en.md)

## Requirement Analysis
Create the autonomous mini-app `features/wallet` using Mason `pac_mvi_feature`. Port over the digital wallet dashboard, token accounts, NFT gallery, and blockchain network selector from `danhdue/full_features:packages/wallet`. Upgrade models to Freezed v3, Slang v4, and ensure strict financial decimal precision.

## Relevant Files & Context Pointers
- `bricks/pac_mvi_feature/`
- `features/wallet/pubspec.yaml`
- `features/wallet/slang.yaml`
- `features/wallet/lib/wallet.dart`
- `features/wallet/lib/wallet_router.dart`
- `features/wallet/lib/domain/usecases/get_wallet_usecase.dart`
- `features/wallet/lib/presentation/wallet/wallet_page.dart`
- `features/wallet/lib/presentation/wallet/wallet_bloc.dart`
- `features/wallet/lib/presentation/token_list/token_list_page.dart`
- `features/wallet/lib/presentation/nfts_list/nfts_list_page.dart`
- `features/wallet/lib/presentation/network_selection/network_selection_page.dart`
- Source legacy reference: `danhdue/full_features:packages/wallet/`

## Design Rationale
- Scaffold package under `features/wallet` with Pub Workspace resolution.
- Ensure all models use Freezed v3 and `@freezed`.
- Implement `WalletRouter` exposing sub-routes (`WalletRoute`, `TokenListRoute`, `NftsListRoute`, `NetworkSelectionRoute`).
- Migrate unit and widget tests for each BLoC.

## Impact Analysis & Blast Radius
- **Target Files & Symbols:** `WalletPage`, `WalletBloc`, `TokenListBloc`, `NftsListBloc`, `NetworkSelectionBloc`, `WalletRouter`.
- **Downstream Callers:** Host `ShellPage` (Tab 0), Host `AppRouter`, `lib/di/injection.dart`.
- **Cross-Platform Bridges:** None.
- **Target Test Coverage Threshold:** $\ge 85\%$ for domain usecases and BLoCs.

## BDD Scenarios & Acceptance Criteria
### BDD SCENARIOS

```gherkin
Scenario: [Tier A - Unit] WalletBloc fetches aggregated balance and tokens
  Given valid wallet credentials in storage
  When WalletBloc processes started action
  Then state transitions: loading -> loaded(balance: "...", tokens: [...])

Scenario: [Tier A - Unit] Wallet handles empty asset collection cleanly
  Given remote wallet client returns empty token list
  When WalletBloc processes response
  Then state displays total balance of 0.00 and shows empty state widget

Scenario: [Tier A - Unit] Network selection updates active blockchain
  Given NetworkSelectionBloc with current network "Ethereum Mainnet"
  When user selects "Solana Devnet"
  Then active network updates in local preferences and emits networkChanged event

Scenario: [Tier C - Integration] WalletPage renders inside ShellPage Tab 0
  Given authenticated user opens Super App Shell
  When Tab 0 is selected
  Then WalletPage renders balances, token list, and action buttons without errors
```

## Test & Verification Checklist
- [ ] **RED**: Author failing unit tests for `WalletBloc`, `TokenListBloc`, `GetWalletUseCase`.
- [ ] **GREEN**: Scaffold package via Mason, migrate models/datasources/usecases/pages, satisfy all unit tests.
- [ ] **REFACTOR**: Run Slang v4 and Freezed v3 codegen, format code (`melos format`), and verify `fvm flutter test` passes.

## Definition of Done (DoD)
- `features/wallet` compiles and passes all unit and widget tests.
- 100% test pass rate with $\ge 85\%$ coverage on pure domain usecases.
- Boundaries check passes.

## Dependencies & Blockers
- Blocked by [Task 02](task_02_scaffold_and_migrate_authentication_feature.md).

## References & Rollback
- Source: `danhdue/full_features:packages/wallet`
- Rollback: `rm -rf features/wallet`
