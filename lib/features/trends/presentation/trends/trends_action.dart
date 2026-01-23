// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// Trends Actions
/// ============================================================================
/// Actions represent user intentions/interactions from the UI.
///
/// HOW TO EXTEND:
/// 1. Create action classes for each user interaction
/// 2. Each action should extend TrendsAction
/// 3. Include any data needed to process the action
///
/// EXAMPLE - Adding actions:
/// ```dart
/// class LoadTrendsAction extends TrendsAction {
///   const LoadTrendsAction();
/// }
///
/// class SubmitTrendsAction extends TrendsAction {
///   final String data;
///   const SubmitTrendsAction(this.data);
/// }
///
/// class RefreshTrendsAction extends TrendsAction {
///   const RefreshTrendsAction();
/// }
/// ```
/// ============================================================================

sealed class TrendsAction extends BaseAction {
  const TrendsAction();
}

/// Initialize action - called when the feature starts
class InitTrendsAction extends TrendsAction {
  const InitTrendsAction();
}
