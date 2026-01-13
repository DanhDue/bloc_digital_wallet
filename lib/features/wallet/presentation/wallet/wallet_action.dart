// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

/// Actions for Wallet feature (INPUT: View → ViewModel)
/// Represents user interactions and system triggers
sealed class WalletAction extends BaseAction {
  const WalletAction();
}

/// Load all wallets
class LoadAllWalletsAction extends WalletAction {
  const LoadAllWalletsAction();
}

/// Load single wallet
class LoadWalletAction extends WalletAction {
  final String id;

  const LoadWalletAction(this.id);
}

/// Create wallet
class CreateWalletAction extends WalletAction {
  final String name;
  // TODO: Add parameters

  const CreateWalletAction({required this.name});
}

/// Update wallet
class UpdateWalletAction extends WalletAction {
  final String id;
  final String name;
  // TODO: Add parameters

  const UpdateWalletAction({required this.id, required this.name});
}

/// Delete wallet
class DeleteWalletAction extends WalletAction {
  final String id;

  const DeleteWalletAction(this.id);
}

/// Refresh wallets
class RefreshWalletsAction extends WalletAction {
  const RefreshWalletsAction();
}
