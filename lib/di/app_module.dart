// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
import '../core/app_initializer/app_initializer.dart';
import '../core/app_initializer/app_initializer_impl.dart';
import '../core/app_initializer/logging_initializer.dart';

@module
abstract class AppModule {
  @singleton
  LoggingInitializer get loggingInitializer => LoggingInitializer();

  @singleton
  AppInitializer provideAppInitializer(LoggingInitializer loggingInitializer) {
    return AppInitializerImpl([loggingInitializer]);
  }
}
