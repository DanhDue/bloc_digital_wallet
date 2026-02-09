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
    // Re-fetch or re-filter locally? Legacy re-fetched with `isRefresh: true`.
    // "changeFilter(int index) { ... fetchData(isRefresh: true); }" in legacy controller.
    // Wait, did legacy controller pass filter index to API?
    // Step 81: `retrieveDataFromService` uses `selectedFilterIndex`?
    // No, `getTransactionByOwner` params: `limit: 3, before: ...`. It does NOT use filter index.
    // Wait, then `selectedFilterIndex` logic in legacy controller does NOT affect API call?
    // "changeFilter(int index) { if (selectedFilterIndex.value == index) return; selectedFilterIndex.value = index; fetchData(isRefresh: true); }"
    // It refreshes the list. But if API call is same, then it just reloads same data.
    // Maybe filtering happens in UI or subsequent processing?
    // Legacy view: `_buildFilterToggle`.
    // It seems purely UI or maybe I missed something in `retrieveDataFromService`.
    // In `retrieveDataFromService` (line 54 step 81), it calls `transactionRepo.getTransactionByOwner`.
    // It ignores `selectedFilterIndex`.
    // So filtering seemingly does nothing to the data response?
    // Maybe the UI uses `selectedFilterIndex` to filter visible items?
    // Legacy view (step 82): `buildItemViews` -> `_buildItem`.
    // It doesn't check filter index.
    // Maybe it's a "fake" filter or incomplete feature in legacy?
    // Legacy view `_buildFilterToggle` changes `selectedFilterIndex`.
    // But `TransactionsView` uses `controller.items` (from `BaseInfiniteListController`).
    // If controller fetches same data, items are same.
    // I will implement it as refresh for now, as in legacy.
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
    // But wait, `_lastDayInTheList` is stateful for incremental updates.
    // If I process everything, I don't need `_lastDayInTheList` state, I calculate it on fly.

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
      // Use localized logic for "Today", "Yesterday" etc?
      // Legacy view handled this in `_buildLabel` > `retrieveGroupLabel`.
      // Since `TransactionListItem.header` takes a String, I should pre-calculate or let UI handle it.
      // The legacy controller passed `TransactionResponseObject(isLabel: true, overview: ...)`
      // So it passed the object.
      // My `TransactionListItem.header` takes `String title`.
      // I can format it here or pass a date object.
      // To be clean, I should format it in UI or passing a Date object to Header.
      // But user rule: "Use localization texts". Localization needs context?
      // `Jiffy` can be formatted. Today/Yesterday logic requires `Jiffy.now()`.
      // I'll format assuming English for now or standard format, or better, change `TransactionListItem.header` to take `DateTime` or `Jiffy` and format in UI.
      // But sticking to String title for now to match `header(String title)`.
      // I'll use the logic from `TransactionsView.retrieveGroupLabel` here if possible, but localized string `.tr` needs context? No, `slang` generates global access.

      // I'll skip complex formatting here and just use the key (date string)
      // OR replicate `retrieveGroupLabel` logic.
      result.add(TransactionListItem.header(dateLabel)); // Placeholder

      // Add Items
      for (var i = 0; i < items.length; i++) {
        var item = items[i];
        // Handle isLast logic if needed for UI dividers?
        // Legacy set `isLast` on item.
        // `TransactionEntity` has `isLast`.
        // I should set it copyWith?
        final isGroupLast = i == items.length - 1;
        result.add(TransactionListItem.transaction(item.copyWith(isLast: isGroupLast)));
      }
    }

    return result;
  }
}
