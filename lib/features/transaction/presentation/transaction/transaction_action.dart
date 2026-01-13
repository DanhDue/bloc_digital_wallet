// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

/// Actions for Transaction feature (INPUT: View → ViewModel)
/// Represents user interactions and system triggers
sealed class TransactionAction extends BaseAction {
  const TransactionAction();
}

/// Load all transactions
class LoadAllTransactionsAction extends TransactionAction {
  const LoadAllTransactionsAction();
}

/// Load single transaction
class LoadTransactionAction extends TransactionAction {
  final String id;

  const LoadTransactionAction(this.id);
}

/// Create transaction
class CreateTransactionAction extends TransactionAction {
  final String name;
  // TODO: Add parameters

  const CreateTransactionAction({required this.name});
}

/// Update transaction
class UpdateTransactionAction extends TransactionAction {
  final String id;
  final String name;
  // TODO: Add parameters

  const UpdateTransactionAction({required this.id, required this.name});
}

/// Delete transaction
class DeleteTransactionAction extends TransactionAction {
  final String id;

  const DeleteTransactionAction(this.id);
}

/// Refresh transactions
class RefreshTransactionsAction extends TransactionAction {
  const RefreshTransactionsAction();
}
