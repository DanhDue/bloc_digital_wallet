// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:trends/data/datasources/remote/trends_remote_datasource.dart';
import 'package:trends/domain/entities/coin_market_entity.dart';
import 'package:trends/domain/entities/coin_market_ohlcv_entity.dart';
import 'package:trends/domain/repositories/trends_repository.dart';

@LazySingleton(as: TrendsRepository)
class TrendsRepositoryImpl implements TrendsRepository {
  final TrendsRemoteDataSource _remoteDataSource;

  TrendsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<CoinMarketEntity>>> getCoinMarkets({
    int page = 1,
    int limit = 20,
    String? convert,
    String? sort,
    String? sortDir,
  }) {
    return _remoteDataSource.getCoinMarkets(
      page: page,
      limit: limit,
      convert: convert,
      sort: sort,
      sortDir: sortDir,
    );
  }

  @override
  Future<Either<Failure, Map<String, CoinMarketEntity>>> getCoinInfo({required String symbol}) {
    return _remoteDataSource.getCoinInfo(symbol: symbol);
  }

  @override
  Future<Either<Failure, CoinMarketEntity>> getCoinPriceConversion({
    required String symbol,
    required double amount,
    String? convert,
  }) {
    return _remoteDataSource.getCoinPriceConversion(
      symbol: symbol,
      amount: amount,
      convert: convert,
    );
  }

  @override
  Future<Either<Failure, List<CoinMarketEntity>>> getGlobalMetrics() {
    return _remoteDataSource.getGlobalMetrics();
  }

  @override
  Future<Either<Failure, List<CoinMarketEntity>>> getMaps() {
    return _remoteDataSource.getMaps();
  }

  @override
  Future<Either<Failure, Map<String, CoinMarketOhlcvEntity>>> getOhlcv({
    required String symbol,
    required String interval,
  }) {
    return _remoteDataSource.getOhlcv(symbol: symbol, interval: interval);
  }
}
