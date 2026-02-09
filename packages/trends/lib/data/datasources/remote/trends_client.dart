// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:trends/data/models/coin_market_model.dart';
import 'package:trends/data/models/coin_market_ohlcv_model.dart';

import 'package:trends/data/models/coin_market_response.dart';

part 'trends_client.g.dart';

@RestApi()
abstract class TrendsClient {
  factory TrendsClient(Dio dio, {String? baseUrl}) = _TrendsClient;

  @GET('')
  Future<CoinMarketResponse> getCoinMarkets({
    @Query('start') int start = 1,
    @Query('limit') int limit = 20,
    @Query('convert') String? convert,
    @Query('sort') String? sort,
    @Query('sort_dir') String? sortDir,
  });

  @GET('/info')
  Future<Map<String, CoinMarketModel>> getCoinInfo({@Query('symbol') required String symbol});

  @GET('/price')
  Future<CoinMarketModel> getCoinPriceConversion({
    @Query('symbol') required String symbol,
    @Query('amount') required double amount,
    @Query('convert') String? convert,
  });

  @GET('/metrics')
  Future<List<CoinMarketModel>> getGlobalMetrics();

  @GET('/maps')
  Future<List<CoinMarketModel>> getMaps();

  @GET('/ohlcv')
  Future<Map<String, CoinMarketOhlcvModel>> getOhlcv({
    @Query('symbol') required String symbol,
    @Query('interval') required String interval,
  });
}
