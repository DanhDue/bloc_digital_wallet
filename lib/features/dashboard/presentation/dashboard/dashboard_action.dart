// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// Dashboard Actions
/// ============================================================================
/// Actions represent user intentions/interactions from the UI.
///
/// HOW TO EXTEND:
/// 1. Create action classes for each user interaction
/// 2. Each action should extend DashboardAction
/// 3. Include any data needed to process the action
///
/// EXAMPLE - Adding actions:
/// ```dart
/// class LoadDashboardAction extends DashboardAction {
///   const LoadDashboardAction();
/// }
///
/// class SubmitDashboardAction extends DashboardAction {
///   final String data;
///   const SubmitDashboardAction(this.data);
/// }
///
/// class RefreshDashboardAction extends DashboardAction {
///   const RefreshDashboardAction();
/// }
/// ```
/// ============================================================================

sealed class DashboardAction extends BaseAction {
  const DashboardAction();
}

/// Initialize action - called when the feature starts
class InitDashboardAction extends DashboardAction {
  const InitDashboardAction();
}
