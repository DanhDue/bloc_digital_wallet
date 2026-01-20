// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:bloc_digital_wallet/core/network/app_uri.dart';
import 'package:bloc_digital_wallet/core/network/base_response_object.dart';
import 'package:bloc_digital_wallet/features/onboard/data/models/base_url_object.dart';

part 'health_check_client.g.dart';

@RestApi()
abstract class HealthCheckClient {
  factory HealthCheckClient(Dio dio, {String baseUrl}) = _HealthCheckClient;

  @GET("${AppUri.healthz}/")
  Future<BaseResponseObject<dynamic>> healthCheck();

  @GET("${AppUri.baseUrl}/")
  Future<BaseResponseObject<List<BaseUrlObject>>> getBaseUrl();
}
