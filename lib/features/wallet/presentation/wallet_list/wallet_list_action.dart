// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// WalletList Actions
/// ============================================================================
/// Actions represent user intents or system events.
///
/// HOW TO EXTEND:
/// 1. Add new action classes for different user intents
/// 2. Each action should extend WalletListAction
/// 3. Include any data needed to process the action
/// ============================================================================

sealed class WalletListAction extends BaseAction {
  const WalletListAction();
}

/// Action to load/initialize the feature
class LoadWalletListAction extends WalletListAction {
  const LoadWalletListAction();
}
