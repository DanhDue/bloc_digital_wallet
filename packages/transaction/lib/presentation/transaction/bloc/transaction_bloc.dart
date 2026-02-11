// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framework/framework.dart';
import 'package:injectable/injectable.dart';
import 'package:transaction/domain/entities/transaction_entity.dart';
import 'package:transaction/domain/usecases/get_transactions_by_owner_usecase.dart';
import 'package:transaction/presentation/transaction/transaction_action.dart';
import 'package:transaction/presentation/transaction/transaction_event.dart';
import 'package:transaction/presentation/transaction/transaction_state.dart';
import 'package:transaction/presentation/transaction/ui_models/transaction_list_item.dart';

@injectable
class TransactionBloc extends MviBloc<TransactionAction, TransactionState, TransactionEvent> {
  final GetTransactionsByOwnerUseCase _getTransactionsByOwnerUseCase;
  static const _ownerAddress = 'CRG9hpv6WpMHhiNZKF9XSjTnfS9SavtTJqhTRc3xG4GZ';
  static const _limit = 20;

  final List<TransactionEntity> _allTransactions = [];

  TransactionBloc(this._getTransactionsByOwnerUseCase) : super(const TransactionState()) {
    on<TransactionAction>((event, emit) async {
      await event.map(
        started: (_) => _onStarted(emit),
        refresh: (_) => _onRefresh(emit),
        loadMore: (_) => _onLoadMore(emit),
        filterChanged: (e) => _onFilterChanged(e.index, emit),
        openTransactionDetail: (e) => _onOpenTransactionDetail(e.transaction, emit),
      );
    });
  }

  @override
  void onAction(TransactionAction action) {
    add(action);
  }

  FutureOr<void> _onStarted(Emitter<TransactionState> emit) async {
    await _loadTransactions(emit, isRefresh: true);
  }

  FutureOr<void> _onRefresh(Emitter<TransactionState> emit) async {
    await _loadTransactions(emit, isRefresh: true);
  }

  FutureOr<void> _onLoadMore(Emitter<TransactionState> emit) async {
    if (state.hasReachedMax || state.isLoading) return;
    await _loadTransactions(emit, isRefresh: false);
  }

  FutureOr<void> _onFilterChanged(int index, Emitter<TransactionState> emit) async {
    if (state.filterIndex == index) return;
    emit(state.copyWith(filterIndex: index));

    // Refresh the list when filter changes to ensure UI consistency
    await _loadTransactions(emit, isRefresh: true);
  }

  FutureOr<void> _onOpenTransactionDetail(
    TransactionEntity transaction,
    Emitter<TransactionState> emit,
  ) {
    emitEvent(TransactionEvent.navigateToDetail(transaction));
  }

  Future<void> _loadTransactions(Emitter<TransactionState> emit, {bool isRefresh = false}) async {
    if (isRefresh) {
      _allTransactions.clear();
      emit(state.copyWith(isLoading: true, error: null, items: [], hasReachedMax: false));
    } else {
      // Don't emit loading for pagination if we want smooth scroll, or handle distinct pagination loading state.
      // Legacy controller handles it efficiently.
    }

    final before = isRefresh
        ? null
        : _allTransactions.lastOrNull?.overview?.signature?.firstOrNull;

    final result = await _getTransactionsByOwnerUseCase(
      _ownerAddress,
      limit: _limit,
      before: before,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, error: failure.message));
        emitEvent(TransactionEvent.showError(failure.message));
      },
      (newTransactions) {
        final isLastPage = newTransactions.length < _limit;
        _allTransactions.addAll(newTransactions);

        final uiItems = _processTransactions(_allTransactions, isRefresh: isRefresh);

        emit(state.copyWith(isLoading: false, items: uiItems, hasReachedMax: isLastPage));
      },
    );
  }

  List<TransactionListItem> _processTransactions(
    List<TransactionEntity> transactions, {
    required bool isRefresh,
  }) {
    // Re-process all transactions from scratch to ensure correct grouping?
    // Legacy `prepareDataBeforeAdding` processes *new* items and appends to result.
    // But since I cleared `_allTransactions` on refresh, passing `_allTransactions` means checking everything?
    // Wait, if I use `_allTransactions`, I should re-group everything.
    // This is safer than incremental grouping for Bloc state which usually emits new immutable list.

    // Reset state for clean processing if we re-process everything
    if (transactions.isEmpty) return [];

    final groupedItems = groupBy(
      transactions,
      (p0) => p0.overview?.timestamp?.yMMMMd,
    ).entries.toList();

    groupedItems.sort(
      (a, b) => (b.value.firstOrNull?.overview?.timestamp?.millisecondsSinceEpoch ?? 0).compareTo(
        a.value.firstOrNull?.overview?.timestamp?.millisecondsSinceEpoch ?? 0,
      ),
    );

    final result = <TransactionListItem>[];

    for (var entry in groupedItems) {
      final dateLabel = entry.key ?? '';
      final items = entry.value;

      // Add Header
      result.add(TransactionListItem.header(dateLabel));

      // Add Items
      for (var i = 0; i < items.length; i++) {
        var item = items[i];
        final isGroupLast = i == items.length - 1;

        // Calculate display/business logic here (ViewModel transformation)
        // 1. Determine direction and amount
        // Prioritize TokenBalances (SPL transfers) over AccountInputs (Native SOL changes)
        // Finding the balance change for the current owner

        final myToken = item.tokenBalances?.firstWhereOrNull((e) => e.address == _ownerAddress);
        final myInput = item.accountInputs?.firstWhereOrNull((e) => e.address == _ownerAddress);

        double change = 0;
        String symbol = '';

        if (myToken != null && myToken.changes != null) {
          // changes is String
          final rawChange = double.tryParse(myToken.changes!) ?? 0;
          change = rawChange;
          // If 'token' is available, use it. It might be mint address, but better than nothing.
          // In real app, we'd map mint to symbol. For now, show truncated or placeholder.
          symbol = 'Token';
        } else if (myInput != null && myInput.changes != null) {
          // changes is int (lamports)
          // 1 SOL = 1,000,000,000 lamports
          change = (myInput.changes ?? 0) / 1000000000;
          symbol = 'SOL';
        }

        final isReceived = change > 0;
        final absChange = change.abs();

        // 2. Format Amount
        // formatting logic: simple string for now.
        // If < 0.0001, maybe show < 0.0001?
        final formattedAmount = '${absChange.toStringAsFixed(absChange < 0.0001 ? 8 : 4)} $symbol';

        // 3. Format Fiat
        // We don't have fiat rates yet.
        final formattedFiatAmount = '-';

        // 4. Format Date
        final formattedTime = item.overview?.timestamp?.yMMMMd ?? '';

        result.add(
          TransactionListItem.transaction(
            item,
            isLast: isGroupLast,
            isReceived: isReceived,
            formattedAmount: formattedAmount,
            formattedFiatAmount: formattedFiatAmount,
            formattedTime: formattedTime,
          ),
        );
      }
    }

    return result;
  }
}
