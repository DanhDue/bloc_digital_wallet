// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framework/framework.dart';
import 'package:injectable/injectable.dart';
import 'package:trends/domain/usecases/get_coin_markets_usecase.dart';
import 'package:trends/presentation/trends/models/coin_market_ui_model.dart';

import 'package:trends/presentation/trends/trends_action.dart';
import 'package:trends/presentation/trends/trends_event.dart';
import 'package:trends/presentation/trends/trends_state.dart';

@injectable
class TrendsBloc extends MviBloc<TrendsAction, TrendsState, TrendsEvent> {
  final GetCoinMarketsUseCase _getCoinMarketsUseCase;
  static const int _itemsPerPage = 20;

  TrendsBloc(this._getCoinMarketsUseCase) : super(const TrendsState()) {
    on<TrendsAction>((action, emit) async {
      await action.when(
        started: () => _onStarted(emit),
        loadMore: () => _onLoadMore(emit),
        search: (keyword) async => _onSearch(emit, keyword),
        searchFocusChanged: (isFocused) async => _onSearchFocusChanged(emit, isFocused),
        historyTap: (keyword) async => _onHistoryTap(emit, keyword),
        micTap: () async => _onMicTap(emit),
      );
    });
  }

  Future<void> _onStarted(Emitter<TrendsState> emit) async {
    emit(state.copyWith(status: TrendsStatus.loading, currentPage: 1));
    await _fetchCoinMarkets(emit, page: 1, isRefresh: true);
  }

  Future<void> _onLoadMore(Emitter<TrendsState> emit) async {
    if (state.status == TrendsStatus.loadingMore || state.hasReachedEnd) return;

    emit(state.copyWith(status: TrendsStatus.loadingMore));
    await _fetchCoinMarkets(emit, page: state.currentPage + 1);
  }

  Future<void> _fetchCoinMarkets(
    Emitter<TrendsState> emit, {
    required int page,
    bool isRefresh = false,
  }) async {
    final result = await _getCoinMarketsUseCase(page: page, limit: _itemsPerPage);

    result.fold(
      (failure) {
        emit(state.copyWith(status: TrendsStatus.failure, errorMessage: failure.message));
        emitEvent(const TrendsEvent.initial());
      },
      (entities) {
        final newCoins = entities.map(CoinMarketUiModel.fromEntity).toList();
        final allCoins = isRefresh ? newCoins : [...state.coins, ...newCoins];
        final filteredCoins = _filterCoins(allCoins, state.searchKeyword);

        emit(
          state.copyWith(
            status: TrendsStatus.success,
            coins: allCoins,
            filteredCoins: filteredCoins,
            currentPage: page,
            hasReachedEnd: newCoins.length < _itemsPerPage,
          ),
        );
      },
    );
  }

  void _onSearch(Emitter<TrendsState> emit, String keyword) {
    final filteredCoins = _filterCoins(state.coins, keyword);
    emit(state.copyWith(searchKeyword: keyword, filteredCoins: filteredCoins));
  }

  void _onSearchFocusChanged(Emitter<TrendsState> emit, bool isFocused) {
    emit(state.copyWith(isSearchFocused: isFocused));
  }

  void _onHistoryTap(Emitter<TrendsState> emit, String keyword) {
    _onSearch(emit, keyword);
  }

  void _onMicTap(Emitter<TrendsState> emit) {
    // Future: trigger voice search
    emitEvent(const TrendsEvent.initial());
  }

  List<CoinMarketUiModel> _filterCoins(List<CoinMarketUiModel> coins, String keyword) {
    if (keyword.isEmpty) return coins;

    final query = keyword.toLowerCase();
    return coins.where((coin) {
      final symbol = coin.symbol.toLowerCase();
      final name = coin.name.toLowerCase();
      return symbol.contains(query) || name.contains(query);
    }).toList();
  }
}
