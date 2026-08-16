// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dio/dio.dart';
import 'package:onboard/data/datasources/remote/onboard_uri.dart';
import 'package:onboard/data/models/base_url_object.dart';
import 'package:retrofit/retrofit.dart';
import 'package:network/base_response_object.dart';

part 'health_check_client.g.dart';

@RestApi()
abstract class HealthCheckClient {
  factory HealthCheckClient(Dio dio, {String? baseUrl}) = _HealthCheckClient;

  @GET("${OnboardUri.healthz}/")
  Future<BaseResponseObject<dynamic>> healthCheck();

  @GET("${OnboardUri.baseUrl}/")
  Future<BaseResponseObject<List<BaseUrlObject>>> getBaseUrl();
}
