// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

part 'coin_market_ohlcv_entity.freezed.dart';

@freezed
abstract class CoinMarketOhlcvEntity with _$CoinMarketOhlcvEntity {
  const CoinMarketOhlcvEntity._();

  const factory CoinMarketOhlcvEntity({
    int? openTime,
    double? open,
    double? high,
    double? low,
    double? close,
    double? volume,
    int? closeTime,
    double? quoteAssetVolume,
    int? numberOfTrades,
  }) = _CoinMarketOhlcvEntity;
}
