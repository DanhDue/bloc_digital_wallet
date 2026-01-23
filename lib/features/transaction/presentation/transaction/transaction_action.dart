// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// Transaction Actions
/// ============================================================================
/// Actions represent user intentions/interactions from the UI.
///
/// HOW TO EXTEND:
/// 1. Create action classes for each user interaction
/// 2. Each action should extend TransactionAction
/// 3. Include any data needed to process the action
///
/// EXAMPLE - Adding actions:
/// ```dart
/// class LoadTransactionAction extends TransactionAction {
///   const LoadTransactionAction();
/// }
///
/// class SubmitTransactionAction extends TransactionAction {
///   final String data;
///   const SubmitTransactionAction(this.data);
/// }
///
/// class RefreshTransactionAction extends TransactionAction {
///   const RefreshTransactionAction();
/// }
/// ```
/// ============================================================================

sealed class TransactionAction extends BaseAction {
  const TransactionAction();
}

/// Initialize action - called when the feature starts
class InitTransactionAction extends TransactionAction {
  const InitTransactionAction();
}
