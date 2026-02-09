// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trends/domain/entities/coin_market_entity.dart';

part 'coin_market_model.freezed.dart';
part 'coin_market_model.g.dart';

/// Data model for coin market API responses.
@freezed
abstract class CoinMarketModel with _$CoinMarketModel {
  const CoinMarketModel._();

  @JsonSerializable(includeIfNull: false)
  const factory CoinMarketModel({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'symbol') required String symbol,
    @JsonKey(name: 'logo') String? logo,
    @JsonKey(name: 'rank') int? rank,
    @JsonKey(name: 'cmc_rank') int? cmcRank,
    @JsonKey(name: 'price') double? price,
    @JsonKey(name: 'volume_24h') double? volume24h,
    @JsonKey(name: 'percent_change_24h') double? percentChange24h,
    @JsonKey(name: 'percent_change_7d') double? percentChange7d,
    @JsonKey(name: 'market_cap') double? marketCap,
    @JsonKey(name: 'market_cap_dominance') double? marketCapDominance,
    @JsonKey(name: 'fully_diluted_market_cap') double? fullyDilutedMarketCap,
    @JsonKey(name: 'circulating_supply') double? circulatingSupply,
    @JsonKey(name: 'max_supply') double? maxSupply,
    @JsonKey(name: 'total_supply') double? totalSupply,
    @JsonKey(name: 'high') double? high,
    @JsonKey(name: 'low') double? low,
    @JsonKey(name: 'open') double? open,
    @JsonKey(name: 'close') double? close,
    @JsonKey(name: 'number_of_trades') int? numberOfTrades,
    @JsonKey(name: 'quote_asset_volume') double? quoteAssetVolume,
    @JsonKey(name: 'description') String? description,
  }) = _CoinMarketModel;

  factory CoinMarketModel.fromJson(Map<String, Object?> json) => _$CoinMarketModelFromJson(json);
}

extension CoinMarketModelX on CoinMarketModel {
  CoinMarketEntity toEntity() {
    return CoinMarketEntity(
      id: id,
      name: name,
      symbol: symbol,
      logo: logo,
      rank: rank,
      cmcRank: cmcRank,
      price: price,
      volume24h: volume24h,
      percentChange24h: percentChange24h,
      percentChange7d: percentChange7d,
      marketCap: marketCap,
      marketCapDominance: marketCapDominance,
      fullyDilutedMarketCap: fullyDilutedMarketCap,
      circulatingSupply: circulatingSupply,
      maxSupply: maxSupply,
      totalSupply: totalSupply,
      high: high,
      low: low,
      open: open,
      close: close,
      numberOfTrades: numberOfTrades,
      quoteAssetVolume: quoteAssetVolume,
      description: description,
    );
  }
}
