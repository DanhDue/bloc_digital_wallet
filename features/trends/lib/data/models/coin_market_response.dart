// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trends/data/models/coin_market_model.dart';

part 'coin_market_response.freezed.dart';
part 'coin_market_response.g.dart';

@freezed
abstract class CoinMarketResponse with _$CoinMarketResponse {
  const factory CoinMarketResponse({
    @JsonKey(name: 'data') required List<CoinMarketModel> data,
    @JsonKey(name: 'status') dynamic status,
  }) = _CoinMarketResponse;

  factory CoinMarketResponse.fromJson(Map<String, dynamic> json) =>
      _$CoinMarketResponseFromJson(json);
}
