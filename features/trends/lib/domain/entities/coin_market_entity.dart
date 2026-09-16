// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

part 'coin_market_entity.freezed.dart';

/// Domain entity representing a cryptocurrency market item.
/// This is a pure domain object - no JSON serialization or Flutter dependencies.
@freezed
abstract class CoinMarketEntity with _$CoinMarketEntity {
  const CoinMarketEntity._();

  const factory CoinMarketEntity({
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
    double? marketCapDominance,
    double? fullyDilutedMarketCap,
    double? circulatingSupply,
    double? maxSupply,
    double? totalSupply,
    double? high,
    double? low,
    double? open,
    double? close,
    int? numberOfTrades,
    double? quoteAssetVolume,
    String? description,
  }) = _CoinMarketEntity;
}
