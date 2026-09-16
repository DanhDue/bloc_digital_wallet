// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trends/domain/entities/coin_market_ohlcv_entity.dart';

part 'coin_market_ohlcv_model.freezed.dart';
part 'coin_market_ohlcv_model.g.dart';

@freezed
abstract class CoinMarketOhlcvModel with _$CoinMarketOhlcvModel {
  const CoinMarketOhlcvModel._();

  @JsonSerializable(includeIfNull: false)
  const factory CoinMarketOhlcvModel({
    @JsonKey(name: 'open_time') int? openTime,
    @JsonKey(name: 'open') double? open,
    @JsonKey(name: 'high') double? high,
    @JsonKey(name: 'low') double? low,
    @JsonKey(name: 'close') double? close,
    @JsonKey(name: 'volume') double? volume,
    @JsonKey(name: 'close_time') int? closeTime,
    @JsonKey(name: 'quote_asset_volume') double? quoteAssetVolume,
    @JsonKey(name: 'number_of_trades') int? numberOfTrades,
  }) = _CoinMarketOhlcvModel;

  factory CoinMarketOhlcvModel.fromJson(Map<String, Object?> json) =>
      _$CoinMarketOhlcvModelFromJson(json);
}

extension CoinMarketOhlcvModelX on CoinMarketOhlcvModel {
  CoinMarketOhlcvEntity toEntity() {
    return CoinMarketOhlcvEntity(
      openTime: openTime,
      open: open,
      high: high,
      low: low,
      close: close,
      volume: volume,
      closeTime: closeTime,
      quoteAssetVolume: quoteAssetVolume,
      numberOfTrades: numberOfTrades,
    );
  }
}
