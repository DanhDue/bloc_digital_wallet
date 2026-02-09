// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:trends/domain/entities/coin_market_entity.dart';
import 'package:trends/domain/entities/coin_market_ohlcv_entity.dart';

abstract class TrendsRepository {
  /// Get paginated list of coin market data.
  /// [page] - Page number starting from 1
  /// [limit] - Number of items per page
  Future<Either<Failure, List<CoinMarketEntity>>> getCoinMarkets({
    int page = 1,
    int limit = 20,
    String? convert,
    String? sort,
    String? sortDir,
  });

  Future<Either<Failure, Map<String, CoinMarketEntity>>> getCoinInfo({required String symbol});

  Future<Either<Failure, CoinMarketEntity>> getCoinPriceConversion({
    required String symbol,
    required double amount,
    String? convert,
  });

  Future<Either<Failure, List<CoinMarketEntity>>> getGlobalMetrics();

  Future<Either<Failure, List<CoinMarketEntity>>> getMaps();

  Future<Either<Failure, Map<String, CoinMarketOhlcvEntity>>> getOhlcv({
    required String symbol,
    required String interval,
  });
}
