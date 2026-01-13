// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/usecases/get_transaction_usecase.dart';
import '../../domain/usecases/get_all_transactions_usecase.dart';
import 'transaction_action.dart';
import 'transaction_state.dart';
import 'transaction_event.dart';

@injectable
class TransactionBloc extends MviBloc<TransactionAction, TransactionState, TransactionEvent> {
  final GetTransactionUseCase getTransactionUseCase;
  final GetAllTransactionsUseCase getAllTransactionsUseCase;

  TransactionBloc({required this.getTransactionUseCase, required this.getAllTransactionsUseCase})
    : super(const TransactionInitial()) {
    // Register action handlers
    handleAction(null, _onLoadAllTransactions);
    handleAction(null, _onLoadTransaction);
    handleAction(null, _onCreateTransaction);
    handleAction(null, _onUpdateTransaction);
    handleAction(null, _onDeleteTransaction);
    handleAction(null, _onRefreshTransactions);
  }

  /// Single entry point for all actions (Following Android pattern)
  /// This is the ONLY method View should call
  @override
  void onAction(TransactionAction action) {
    add(action);
  }

  Future<void> _onLoadAllTransactions(
    LoadAllTransactionsAction action,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());

    final result = await getAllTransactionsUseCase();

    result.fold(
      (failure) {
        emit(TransactionError(failure.message));
        emitEvent(ShowErrorMessage(failure.message));
      },
      (items) {
        if (items.isEmpty) {
          emit(const TransactionEmpty());
        } else {
          emit(TransactionsLoaded(items));
        }
      },
    );
  }

  Future<void> _onLoadTransaction(
    LoadTransactionAction action,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());

    final result = await getTransactionUseCase(action.id);

    result.fold((failure) {
      emit(TransactionError(failure.message));
      emitEvent(ShowErrorMessage(failure.message));
    }, (item) => emit(TransactionLoaded(item)));
  }

  Future<void> _onCreateTransaction(
    CreateTransactionAction action,
    Emitter<TransactionState> emit,
  ) async {
    // TODO: Implement create logic
    emitEvent(const ShowSuccessMessage('Created successfully'));
  }

  Future<void> _onUpdateTransaction(
    UpdateTransactionAction action,
    Emitter<TransactionState> emit,
  ) async {
    // TODO: Implement update logic
    emitEvent(const ShowSuccessMessage('Updated successfully'));
  }

  Future<void> _onDeleteTransaction(
    DeleteTransactionAction action,
    Emitter<TransactionState> emit,
  ) async {
    // TODO: Implement delete logic
    emitEvent(const ShowSuccessMessage('Deleted successfully'));
  }

  Future<void> _onRefreshTransactions(
    RefreshTransactionsAction action,
    Emitter<TransactionState> emit,
  ) async {
    // Reload all items
    add(const LoadAllTransactionsAction());
  }
}
