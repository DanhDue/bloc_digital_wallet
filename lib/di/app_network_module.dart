// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:network/network.dart';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Main app DI module for coordinating Dio setup with AuthInterceptor.
///
/// This module handles cross-package dependency coordination that cannot
/// be done within individual packages (e.g., adding auth interceptors to Dio).
@module
abstract class AppNetworkModule {
  @singleton
  AuthInterceptor provideAuthInterceptor(
    Dio dio,
    AuthLocalDataSource localDataSource,
    TokenRefresher tokenRefresher,
    Talker talker,
    AuthStreamService authStreamService,
  ) {
    // We inject the Dio instance provided by NetworkModule here just to configure it
    final authInterceptor = AuthInterceptor(
      dio,
      localDataSource,
      tokenRefresher,
      talker,
      authStreamService,
    );
    // Add the interceptor to the global Dio instance
    dio.interceptors.add(authInterceptor);
    return authInterceptor;
  }
}
