// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:app_links/app_links.dart';
import 'package:app_platform/platform.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:d3_nexus_shield/app_router.dart';
import 'package:d3_nexus_shield/core/app_initializer/bloc_observer_initializer.dart';
import 'package:d3_nexus_shield/core/app_initializer/environment_initializer.dart';
import 'package:d3_nexus_shield/core/app_initializer/localization_initializer.dart';
import 'package:d3_nexus_shield/core/app_initializer/logging_initializer.dart';

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
  AppLinks get appLinks => AppLinks();

  @singleton
  DeepLinkParser get deepLinkParser => const DeepLinkParser();

  @singleton
  AppInitializer provideAppInitializer(
    LoggingInitializer loggingInitializer,
    LocalizationInitializer localizationInitializer,
    EnvironmentInitializer environmentInitializer,
    BlocObserverInitializer blocObserverInitializer,
  ) {
    return AppInitializerImpl([
      loggingInitializer,
      localizationInitializer,
      environmentInitializer,
      blocObserverInitializer,
    ]);
  }
}
