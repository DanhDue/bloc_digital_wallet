// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// NftsList Actions
/// ============================================================================
/// Actions represent user intents or system events.
///
/// HOW TO EXTEND:
/// 1. Add new action classes for different user intents
/// 2. Each action should extend NftsListAction
/// 3. Include any data needed to process the action
/// ============================================================================

sealed class NftsListAction extends BaseAction {
  const NftsListAction();
}

/// Action to load/initialize the feature
class LoadNftsListAction extends NftsListAction {
  const LoadNftsListAction();
}
