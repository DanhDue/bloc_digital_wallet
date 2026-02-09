// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:bloc_digital_wallet/app_router.dart';
import 'package:bloc_digital_wallet/core/app_initializer/auth_navigation_initializer.dart';
import 'package:bloc_digital_wallet/core/app_initializer/bloc_observer_initializer.dart';
import 'package:bloc_digital_wallet/core/app_initializer/environment_initializer.dart';
import 'package:bloc_digital_wallet/core/app_initializer/localization_initializer.dart';
import 'package:bloc_digital_wallet/core/app_initializer/logging_initializer.dart';

@module
abstract class AppModule {
  @singleton
  LoggingInitializer get loggingInitializer => LoggingInitializer();

  @singleton
  LocalizationInitializer get localizationInitializer => LocalizationInitializer();

  @singleton
  EnvironmentInitializer get environmentInitializer => EnvironmentInitializer();

  @singleton
  BlocObserverInitializer get blocObserverInitializer => BlocObserverInitializer();

  @singleton
  AppRouter get appRouter => AppRouter();

  @singleton
  AuthNavigationInitializer authNavigationInitializer(
    AuthStreamService authService,
    AppRouter appRouter,
  ) => AuthNavigationInitializer(authService, appRouter);

  @singleton
  AppInitializer provideAppInitializer(
    LoggingInitializer loggingInitializer,
    LocalizationInitializer localizationInitializer,
    EnvironmentInitializer environmentInitializer,
    BlocObserverInitializer blocObserverInitializer,
    AuthNavigationInitializer authNavigationInitializer,
  ) {
    return AppInitializerImpl([
      loggingInitializer,
      localizationInitializer,
      environmentInitializer,
      blocObserverInitializer,
      authNavigationInitializer,
    ]);
  }
}
