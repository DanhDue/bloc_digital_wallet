// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:trends/domain/usecases/get_coin_markets_usecase.dart';
import 'package:trends/presentation/trends/models/coin_market_ui_model.dart';
import 'package:trends/presentation/trends/trends_event.dart';
import 'package:trends/presentation/trends/trends_state.dart';
import 'package:ui_kit/components/infinite_list/base_infinite_list_bloc.dart';
import 'package:ui_kit/components/infinite_list/base_infinite_list_state.dart';

@injectable
class TrendsBloc extends BaseInfiniteListBloc<CoinMarketUiModel> {
  static const _maxSearchHistorySize = 10;
  final GetCoinMarketsUseCase _getCoinMarketsUseCase;

  TrendsBloc(this._getCoinMarketsUseCase) : super(initialState: const TrendsState()) {
    // Register custom search event handlers
    on<TrendsSearch>(_onSearch);
    on<TrendsSearchFocusChanged>(_onSearchFocusChanged);
    on<TrendsHistoryTap>(_onHistoryTap);
    on<TrendsMicTap>(_onMicTap);
    on<TrendsSearchSubmitted>(_onSearchSubmitted);
  }

  /// Returns the state cast to TrendsState for access to search-specific fields.
  TrendsState get trendsState => state as TrendsState;

  @override
  Future<List<CoinMarketUiModel>> fetchItems({required int page, required int limit}) async {
    final result = await _getCoinMarketsUseCase(page: page + 1, limit: limit);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (entities) => entities.map(CoinMarketUiModel.fromEntity).toList(),
    );
  }

  void _onSearch(TrendsSearch event, Emitter<BaseInfiniteListState<CoinMarketUiModel>> emit) {
    emit(trendsState.copyWith(searchKeyword: event.keyword));
  }

  void _onSearchFocusChanged(
    TrendsSearchFocusChanged event,
    Emitter<BaseInfiniteListState<CoinMarketUiModel>> emit,
  ) {
    emit(trendsState.copyWith(isSearchFocused: event.isFocused));
  }

  void _onHistoryTap(
    TrendsHistoryTap event,
    Emitter<BaseInfiniteListState<CoinMarketUiModel>> emit,
  ) {
    emit(trendsState.copyWith(searchKeyword: event.keyword));
  }

  void _onMicTap(TrendsMicTap event, Emitter<BaseInfiniteListState<CoinMarketUiModel>> emit) {
    // Future: trigger voice search
  }

  void _onSearchSubmitted(
    TrendsSearchSubmitted event,
    Emitter<BaseInfiniteListState<CoinMarketUiModel>> emit,
  ) {
    if (event.keyword.isEmpty) return;

    final currentHistory = List<String>.from(trendsState.searchHistory);
    // Remove if exists to move to top
    currentHistory.remove(event.keyword);
    // Add to top
    currentHistory.insert(0, event.keyword);
    // Limit to 10
    if (currentHistory.length > _maxSearchHistorySize) {
      currentHistory.removeLast();
    }

    emit(trendsState.copyWith(searchHistory: currentHistory));
  }
}
