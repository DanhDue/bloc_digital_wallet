// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_digital_wallet/features/wallet/data/datasources/remote/token_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../core/network/app_uri.dart';
import '../../core/network/interceptors/auth_interceptor.dart';
import '../../core/services/auth_stream_service.dart';
import '../../core/utils/extensions/string_ext.dart';
import '../../features/authentication/data/datasources/local/auth_local_datasource.dart';
import '../../features/authentication/data/datasources/remote/auth_client.dart';
import '../../features/onboard/data/datasources/health_check_client.dart';
import '../core/network/dio_factory.dart';

@module
abstract class NetworkModule {
  @singleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();
  Dio provideDio(
    Talker talker,
    AuthLocalDataSource localDataSource,
    AuthStreamService authStreamService,
  ) {
    final dio = DioFactory(talker).dio;

    // Create a separate basic Dio for the AuthClient used inside the interceptor
    // to avoid circular dependency and infinite loops during refresh.
    final refreshDio = DioFactory(talker).dio;

    // AuthClient for refresh logic
    final authClient = AuthClient(refreshDio, baseUrl: AppUri.users.buildAppUri()!);

    final authInterceptor = AuthInterceptor(
      dio,
      localDataSource,
      authClient,
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

  @singleton
  TokenClient provideTokenClient(Dio dio) =>
      TokenClient(dio, baseUrl: AppUri.tokens.buildAppUri()!);
}
