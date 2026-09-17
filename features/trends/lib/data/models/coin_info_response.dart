// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trends/data/models/coin_market_model.dart';

part 'coin_info_response.freezed.dart';
part 'coin_info_response.g.dart';

@freezed
abstract class CoinInfoResponse with _$CoinInfoResponse {
  const CoinInfoResponse._();

  const factory CoinInfoResponse({
    @JsonKey(name: 'data') required Map<String, CoinMarketModel> data,
    @JsonKey(name: 'status') dynamic status,
  }) = _CoinInfoResponse;

  factory CoinInfoResponse.fromJson(Map<String, dynamic> json) => _$CoinInfoResponseFromJson(json);
}
