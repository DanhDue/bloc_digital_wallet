// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trends/presentation/trends/models/coin_market_ui_model.dart';

part 'trends_state.freezed.dart';

enum TrendsStatus { initial, loading, loadingMore, success, failure }

@freezed
abstract class TrendsState extends BaseState with _$TrendsState {
  const TrendsState._();

  const factory TrendsState({
    @Default(TrendsStatus.initial) TrendsStatus status,
    @Default([]) List<CoinMarketUiModel> coins,
    @Default([]) List<CoinMarketUiModel> filteredCoins,
    @Default('') String searchKeyword,
    @Default(['Bitcoin', 'Ethereum', 'Solana']) List<String> searchHistory,
    @Default(false) bool isSearchFocused,
    @Default(1) int currentPage,
    @Default(false) bool hasReachedEnd,
    String? errorMessage,
  }) = _TrendsState;
}
