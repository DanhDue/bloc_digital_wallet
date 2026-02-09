// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:trends/data/models/coin_info_response.dart';
import 'package:trends/data/models/coin_market_response.dart';
import 'package:trends/data/models/coin_ohlcv_response.dart';
import 'package:trends/data/models/coin_price_conversion_response.dart';

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
  Future<CoinInfoResponse> getCoinInfo({@Query('symbol') required String symbol});

  @GET('/price')
  Future<CoinPriceConversionResponse> getCoinPriceConversion({
    @Query('symbol') required String symbol,
    @Query('amount') required double amount,
    @Query('convert') String? convert,
  });

  @GET('/ohlcv')
  Future<CoinOhlcvResponse> getOhlcv({
    @Query('symbol') required String symbol,
    @Query('interval') required String interval,
  });
}
