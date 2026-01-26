// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_digital_wallet/features/wallet/data/models/network_object.dart';
import 'package:bloc_digital_wallet/features/wallet/domain/entities/wallet_entity.dart';
import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// Wallet Actions
/// ============================================================================
/// Actions represent user intentions/interactions from the UI.
///
/// HOW TO EXTEND:
/// 1. Create action classes for each user interaction
/// 2. Each action should extend WalletAction
/// 3. Include any data needed to process the action
///
/// EXAMPLE - Adding actions:
/// ```dart
/// class LoadWalletAction extends WalletAction {
///   const LoadWalletAction();
/// }
///
/// class SubmitWalletAction extends WalletAction {
///   final String data;
///   const SubmitWalletAction(this.data);
/// }
///
/// class RefreshWalletAction extends WalletAction {
///   const RefreshWalletAction();
/// }
/// ```
/// ============================================================================

sealed class WalletAction extends BaseAction {
  const WalletAction();
}

/// Initialize action - called when the feature starts
class InitWalletAction extends WalletAction {
  const InitWalletAction();
}

class SelectNetworkAction extends WalletAction {
  final NetworkObject network;
  const SelectNetworkAction(this.network);
}

class SelectWalletAction extends WalletAction {
  final WalletEntity wallet;
  const SelectWalletAction(this.wallet);
}
