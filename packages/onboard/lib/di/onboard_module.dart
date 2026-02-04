// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:dio/dio.dart';
import 'package:onboard/data/datasources/remote/health_check_client.dart';
import 'package:onboard/di/onboard_module.config.dart';

@InjectableInit(initializerName: r'$initModuleGetIt')
void configureModuleDependencies(GetIt getIt) => getIt.$initModuleGetIt();

@module
abstract class OnboardModule {
  @lazySingleton
  HealthCheckClient getHealthCheckClient(Dio dio) => HealthCheckClient(dio);
}
