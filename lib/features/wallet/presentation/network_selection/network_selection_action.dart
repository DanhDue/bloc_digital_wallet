// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// NetworkSelection Actions
/// ============================================================================
/// Actions represent user intents or system events.
///
/// HOW TO EXTEND:
/// 1. Add new action classes for different user intents
/// 2. Each action should extend NetworkSelectionAction
/// 3. Include any data needed to process the action
/// ============================================================================

sealed class NetworkSelectionAction extends BaseAction {
  const NetworkSelectionAction();
}

/// Action to load/initialize the feature
class LoadNetworkSelectionAction extends NetworkSelectionAction {
  const LoadNetworkSelectionAction();
}

/// Action to search networks
class SearchNetworkSelectionAction extends NetworkSelectionAction {
  final String query;
  const SearchNetworkSelectionAction(this.query);
}
