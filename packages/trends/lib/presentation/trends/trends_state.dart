// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:ui_kit/components/infinite_list/base_infinite_list_state.dart';
import 'package:trends/presentation/trends/models/coin_market_ui_model.dart';

/// Extended state for Trends feature with search functionality.
class TrendsState extends BaseInfiniteListState<CoinMarketUiModel> {
  final String searchKeyword;
  final List<String> searchHistory;
  final bool isSearchFocused;

  const TrendsState({
    super.status,
    super.items,
    super.hasReachedMax,
    super.errorMessage,
    super.isRefreshing,
    super.isLoadingMore,
    this.searchKeyword = '',
    this.searchHistory = const [],
    this.isSearchFocused = false,
  });

  /// Returns the items to display (filtered if search is active, otherwise all items).
  List<CoinMarketUiModel> get displayItems {
    if (searchKeyword.isEmpty) return items;

    final query = searchKeyword.toLowerCase();
    return items.where((coin) {
      final symbol = coin.symbol.toLowerCase();
      final name = coin.name.toLowerCase();
      return symbol.contains(query) || name.contains(query);
    }).toList();
  }

  @override
  TrendsState copyWith({
    InfiniteListStatus? status,
    List<CoinMarketUiModel>? items,
    bool? hasReachedMax,
    String? errorMessage,
    bool? isRefreshing,
    bool? isLoadingMore,
    String? searchKeyword,
    List<String>? searchHistory,
    bool? isSearchFocused,
  }) {
    return TrendsState(
      status: status ?? this.status,
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      searchHistory: searchHistory ?? this.searchHistory,
      isSearchFocused: isSearchFocused ?? this.isSearchFocused,
    );
  }

  @override
  List<Object?> get props => [...super.props, searchKeyword, searchHistory, isSearchFocused];
}
