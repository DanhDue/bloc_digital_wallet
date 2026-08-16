// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:onboard/data/datasources/remote/health_check_client.dart';

@module
abstract class OnboardNetworkModule {
  @lazySingleton
  HealthCheckClient getHealthCheckClient(Dio dio) => HealthCheckClient(dio);
}
