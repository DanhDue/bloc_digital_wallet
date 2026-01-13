// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/entities/transaction_entity.dart';

/// States for Transaction feature
sealed class TransactionState extends BaseState with EquatableMixin {
  const TransactionState();
}

/// Initial state
class TransactionInitial extends TransactionState {
  const TransactionInitial();

  @override
  List<Object?> get props => [];
}

/// Loading state
class TransactionLoading extends TransactionState {
  const TransactionLoading();

  @override
  List<Object?> get props => [];
}

/// Loaded state with list
class TransactionsLoaded extends TransactionState {
  final List<TransactionEntity> items;

  const TransactionsLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

/// Loaded state with single item
class TransactionLoaded extends TransactionState {
  final TransactionEntity item;

  const TransactionLoaded(this.item);

  @override
  List<Object?> get props => [item];
}

/// Error state
class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Empty state
class TransactionEmpty extends TransactionState {
  const TransactionEmpty();

  @override
  List<Object?> get props => [];
}
