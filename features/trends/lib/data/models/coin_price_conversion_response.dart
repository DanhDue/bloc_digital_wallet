// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trends/data/models/coin_market_model.dart';

part 'coin_price_conversion_response.freezed.dart';
part 'coin_price_conversion_response.g.dart';

@freezed
abstract class CoinPriceConversionResponse with _$CoinPriceConversionResponse {
  const CoinPriceConversionResponse._();

  const factory CoinPriceConversionResponse({
    @JsonKey(name: 'data') required CoinMarketModel data,
    @JsonKey(name: 'status') dynamic status,
  }) = _CoinPriceConversionResponse;

  factory CoinPriceConversionResponse.fromJson(Map<String, dynamic> json) =>
      _$CoinPriceConversionResponseFromJson(json);
}
