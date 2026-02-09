// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:framework/framework.dart';
import 'package:injectable/injectable.dart';
import 'package:trends/data/datasources/remote/trends_client.dart';
import 'package:trends/data/models/coin_market_model.dart';
import 'package:trends/data/models/coin_market_ohlcv_model.dart';
import 'package:trends/domain/entities/coin_market_entity.dart';
import 'package:trends/domain/entities/coin_market_ohlcv_entity.dart';

@lazySingleton
class TrendsRemoteDataSource with SafeCallApiMixin {
  final TrendsClient _client;
  static const int _itemsPerPage = 20;

  TrendsRemoteDataSource(this._client);

  Future<Either<Failure, List<CoinMarketEntity>>> getCoinMarkets({
    int page = 1,
    int limit = 20,
    String? convert,
    String? sort,
    String? sortDir,
  }) async {
    final start = (page - 1) * _itemsPerPage + 1;
    final result = await safeApiCall(
      () => _client.getCoinMarkets(
        start: start,
        limit: limit,
        convert: convert,
        sort: sort,
        sortDir: sortDir,
      ),
    );
    return result.map((response) => response.data.map((model) => model.toEntity()).toList());
  }

  Future<Either<Failure, Map<String, CoinMarketEntity>>> getCoinInfo({
    required String symbol,
  }) async {
    final result = await safeApiCall(() => _client.getCoinInfo(symbol: symbol));
    return result.map((map) => map.map((key, value) => MapEntry(key, value.toEntity())));
  }

  Future<Either<Failure, CoinMarketEntity>> getCoinPriceConversion({
    required String symbol,
    required double amount,
    String? convert,
  }) async {
    final result = await safeApiCall(
      () => _client.getCoinPriceConversion(symbol: symbol, amount: amount, convert: convert),
    );
    return result.map((model) => model.toEntity());
  }

  Future<Either<Failure, List<CoinMarketEntity>>> getGlobalMetrics() async {
    final result = await safeApiCall(() => _client.getGlobalMetrics());
    return result.map((models) => models.map((model) => model.toEntity()).toList());
  }

  Future<Either<Failure, List<CoinMarketEntity>>> getMaps() async {
    final result = await safeApiCall(() => _client.getMaps());
    return result.map((models) => models.map((model) => model.toEntity()).toList());
  }

  Future<Either<Failure, Map<String, CoinMarketOhlcvEntity>>> getOhlcv({
    required String symbol,
    required String interval,
  }) async {
    final result = await safeApiCall(() => _client.getOhlcv(symbol: symbol, interval: interval));
    return result.map((map) => map.map((key, value) => MapEntry(key, value.toEntity())));
  }
}
