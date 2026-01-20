// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// Onboard Actions
/// ============================================================================
/// Actions represent user intentions/interactions from the UI.
///
/// HOW TO EXTEND:
/// 1. Create action classes for each user interaction
/// 2. Each action should extend OnboardAction
/// 3. Include any data needed to process the action
///
/// EXAMPLE - Adding actions:
/// ```dart
/// class LoadOnboardAction extends OnboardAction {
///   const LoadOnboardAction();
/// }
///
/// class SubmitOnboardAction extends OnboardAction {
///   final String data;
///   const SubmitOnboardAction(this.data);
/// }
///
/// class RefreshOnboardAction extends OnboardAction {
///   const RefreshOnboardAction();
/// }
/// ```
/// ============================================================================

sealed class OnboardAction extends BaseAction {
  const OnboardAction();
}

/// Initialize action - called when the feature starts
class InitOnboardAction extends OnboardAction {
  const InitOnboardAction();
}
