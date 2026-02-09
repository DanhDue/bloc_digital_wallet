// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trends/domain/entities/coin_market_entity.dart';

part 'coin_market_ui_model.freezed.dart';

/// UI model for coin market items displayed in the trends list.
@freezed
abstract class CoinMarketUiModel with _$CoinMarketUiModel {
  const CoinMarketUiModel._();

  const factory CoinMarketUiModel({
    required int id,
    required String name,
    required String symbol,
    String? logo,
    int? rank,
    int? cmcRank,
    double? price,
    double? volume24h,
    double? percentChange24h,
    double? percentChange7d,
    double? marketCap,
  }) = _CoinMarketUiModel;

  factory CoinMarketUiModel.fromEntity(CoinMarketEntity entity) {
    return CoinMarketUiModel(
      id: entity.id,
      name: entity.name,
      symbol: entity.symbol,
      logo: entity.logo,
      rank: entity.rank,
      cmcRank: entity.cmcRank,
      price: entity.price,
      volume24h: entity.volume24h,
      percentChange24h: entity.percentChange24h,
      percentChange7d: entity.percentChange7d,
      marketCap: entity.marketCap,
    );
  }

  /// Display rank preferring cmcRank, falling back to rank
  int? get displayRank => cmcRank ?? rank;

  /// Check if price change is negative
  bool get isPriceDown => (percentChange24h ?? 0) < 0;

  /// Formatted price change string
  String get priceChangeFormatted {
    if (percentChange24h == null) return '0.00%';
    final sign = percentChange24h! >= 0 ? '+' : '';
    return '$sign${percentChange24h!.toStringAsFixed(2)}%';
  }
}
