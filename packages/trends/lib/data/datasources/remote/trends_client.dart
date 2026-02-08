// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:trends/data/models/trends_model.dart';

part 'trends_client.g.dart';

@RestApi()
abstract class TrendsClient {
  factory TrendsClient(Dio dio, {String? baseUrl}) = _TrendsClient;

  @GET('/trends')
  Future<TrendsModel> getTrends();
}
