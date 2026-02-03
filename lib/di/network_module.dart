// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_digital_wallet/core/auth/auth_local_datasource.dart';
import 'package:bloc_digital_wallet/core/network/app_uri.dart';
import 'package:bloc_digital_wallet/core/network/dio_factory.dart';
import 'package:bloc_digital_wallet/core/network/interceptors/auth_interceptor.dart';
import 'package:bloc_digital_wallet/core/network/ssl/ssl.dart';
import 'package:bloc_digital_wallet/core/services/auth_stream_service.dart';
import 'package:bloc_digital_wallet/core/utils/extensions/string_ext.dart';
import 'package:bloc_digital_wallet/features/authentication/data/datasources/remote/auth_client.dart';
import 'package:bloc_digital_wallet/features/authentication/data/datasources/remote/auth_token_refresher.dart';
import 'package:bloc_digital_wallet/features/onboard/data/datasources/health_check_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';

@module
abstract class NetworkModule {
  @singleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  /// SSL Configuration Strategy
  ///
  /// Options:
  /// - [DebugSslConfiguration] - Accepts all certificates (dev only)
  /// - [HardenedSslPinning] - FFI-based fingerprint validation (production)
  /// - [AutoSslConfiguration] - Auto-selects based on build mode (recommended)
  @singleton
  SslConfiguration get sslConfiguration => const AutoSslConfiguration();

  Dio provideDio(
    Talker talker,
    AuthLocalDataSource localDataSource,
    AuthStreamService authStreamService,
    SslConfiguration sslConfiguration,
  ) {
    final dio = DioFactory(talker, sslConfiguration: sslConfiguration).dio;

    // Create a separate basic Dio for the AuthClient used inside the interceptor
    // to avoid circular dependency and infinite loops during refresh.
    final refreshDio = DioFactory(talker, sslConfiguration: sslConfiguration).dio;

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

  @singleton
  HealthCheckClient provideHealthCheckClient(Dio dio) => HealthCheckClient(dio);

  @singleton
  AuthClient provideAuthClient(Dio dio) => AuthClient(dio, baseUrl: AppUri.users.buildAppUri()!);
}
