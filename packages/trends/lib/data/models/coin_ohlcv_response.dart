// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trends/data/models/coin_market_ohlcv_model.dart';

part 'coin_ohlcv_response.freezed.dart';
part 'coin_ohlcv_response.g.dart';

@freezed
abstract class CoinOhlcvResponse with _$CoinOhlcvResponse {
  const CoinOhlcvResponse._();

  const factory CoinOhlcvResponse({
    @JsonKey(name: 'data') required Map<String, CoinMarketOhlcvModel> data,
    @JsonKey(name: 'status') dynamic status,
  }) = _CoinOhlcvResponse;

  factory CoinOhlcvResponse.fromJson(Map<String, dynamic> json) =>
      _$CoinOhlcvResponseFromJson(json);
}
