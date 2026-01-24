// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// D3Votion Actions
/// ============================================================================
/// Actions represent user intentions/interactions from the UI.
///
/// HOW TO EXTEND:
/// 1. Create action classes for each user interaction
/// 2. Each action should extend D3VotionAction
/// 3. Include any data needed to process the action
///
/// EXAMPLE - Adding actions:
/// ```dart
/// class LoadD3VotionAction extends D3VotionAction {
///   const LoadD3VotionAction();
/// }
///
/// class SubmitD3VotionAction extends D3VotionAction {
///   final String data;
///   const SubmitD3VotionAction(this.data);
/// }
///
/// class RefreshD3VotionAction extends D3VotionAction {
///   const RefreshD3VotionAction();
/// }
/// ```
/// ============================================================================

sealed class D3VotionAction extends BaseAction {
  const D3VotionAction();
}

/// Initialize action - called when the feature starts
class InitD3VotionAction extends D3VotionAction {
  const InitD3VotionAction();
}
