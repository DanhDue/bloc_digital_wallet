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
  @Named('refreshDio')
  Dio provideRefreshDio(SslConfiguration sslConfiguration, Talker talker) => DioFactory(
    talker,
    sslConfiguration: sslConfiguration,
    baseUrl: EnvironmentConfig.apiBaseUrl,
    enableLogging: EnvironmentConfig.enableLogging,
  ).dio;

  @singleton
  AuthClient provideAuthClient(@Named('refreshDio') Dio refreshDio) =>
      AuthClient(refreshDio, baseUrl: AppUri.users.buildAppUri()!);

  @singleton
  AuthTokenRefresher provideTokenRefresher(AuthClient authClient) =>
      AuthTokenRefresher(authClient);

  @singleton
  AuthInterceptor provideAuthInterceptor(
    Dio dio,
    AuthLocalDataSource localDataSource,
    AuthTokenRefresher tokenRefresher,
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
