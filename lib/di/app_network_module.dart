// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:network/network.dart';
import 'package:authentication/data/datasources/remote/auth_client.dart';
import 'package:authentication/data/datasources/remote/auth_token_refresher.dart';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Main app DI module for coordinating Dio setup with AuthInterceptor.
///
/// This module handles cross-package dependency coordination that cannot
/// be done within individual packages (e.g., adding auth interceptors to Dio).
@module
abstract class AppNetworkModule {
  /// Provides a configured Dio instance with authentication interceptor.
  ///
  /// The AuthInterceptor requires dependencies from multiple packages:
  /// - Dio from network
  /// - AuthLocalDataSource & AuthStreamService from core
  /// - TokenRefresher from authentication
  @singleton
  Dio provideDio(
    Talker talker,
    AuthLocalDataSource localDataSource,
    AuthStreamService authStreamService,
    SslConfiguration sslConfiguration,
  ) {
    final dio = DioFactory(
      talker,
      sslConfiguration: sslConfiguration,
      baseUrl: EnvironmentConfig.apiBaseUrl,
      enableLogging: EnvironmentConfig.enableLogging,
    ).dio;

    // Create a separate basic Dio for the AuthClient used inside the interceptor
    // to avoid circular dependency and infinite loops during refresh.
    final refreshDio = DioFactory(
      talker,
      sslConfiguration: sslConfiguration,
      baseUrl: EnvironmentConfig.apiBaseUrl,
      enableLogging: EnvironmentConfig.enableLogging,
    ).dio;

    // AuthClient for refresh logic (uses separate Dio without AuthInterceptor)
    final authClient = AuthClient(refreshDio, baseUrl: AppUri.users.buildAppUri()!);

    // TokenRefresher adapter that wraps AuthClient (DIP: core depends on abstraction)
    final tokenRefresher = AuthTokenRefresher(authClient);

    final authInterceptor = AuthInterceptor(
      dio,
      localDataSource,
      tokenRefresher,
      talker,
      authStreamService,
    );
    dio.interceptors.add(authInterceptor);

    return dio;
  }
}
