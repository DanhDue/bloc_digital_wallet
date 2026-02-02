// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_digital_wallet/config/environment_config.dart';
import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'ssl/ssl.dart';

class DioFactory {
  final Talker _talker;
  final SslConfiguration _sslConfiguration;

  Duration _connectTimeout = const Duration(minutes: 1);
  Duration _receiveTimeout = const Duration(minutes: 1);

  /// Creates a DioFactory with optional SSL configuration.
  ///
  /// [talker] - Logger instance for debugging
  /// [sslConfiguration] - SSL pinning strategy (default: AutoSslConfiguration)
  ///
  /// Available strategies:
  /// - [DebugSslConfiguration] - Accepts all certificates (dev only)
  /// - [HardenedSslPinning] - FFI-based fingerprint validation
  /// - [AutoSslConfiguration] - Auto-selects based on build mode (recommended)
  DioFactory(this._talker, {SslConfiguration sslConfiguration = const AutoSslConfiguration()})
    : _sslConfiguration = sslConfiguration;

  DioFactory withConnectTimeout(Duration timeout) {
    _connectTimeout = timeout;
    return this;
  }

  DioFactory withReceiveTimeout(Duration timeout) {
    _receiveTimeout = timeout;
    return this;
  }

  Dio? _dio;

  Dio get dio {
    _dio ??= _createDio();
    return _dio!;
  }

  Dio _createDio() {
    final baseUrl = EnvironmentConfig.apiBaseUrl;

    final dioInstance = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );

    if (EnvironmentConfig.enableLogging) {
      dioInstance.interceptors.add(
        TalkerDioLogger(
          talker: _talker,
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printResponseHeaders: false,
            printRequestData: true,
            printResponseData: true,
          ),
        ),
      );
    }

    // AuthInterceptor is added via Dependency Injection in NetworkModule

    // Apply SSL configuration strategy
    _sslConfiguration.configure(dioInstance, _talker);

    return dioInstance;
  }
}
