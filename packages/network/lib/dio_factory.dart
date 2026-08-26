// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'interceptors/trace_context_interceptor.dart';
import 'ssl/ssl.dart';

class DioFactory {
  final Talker _talker;
  final SslConfiguration _sslConfiguration;

  Duration _connectTimeout = const Duration(seconds: 30);
  Duration _receiveTimeout = const Duration(seconds: 30);

  final String _baseUrl;
  final bool _enableLogging;

  /// Creates a DioFactory with optional SSL configuration.
  ///
  /// [talker] - Logger instance for debugging
  /// [baseUrl] - The base URL for the API
  /// [enableLogging] - Whether to enable logging (default: false)
  /// [sslConfiguration] - SSL pinning strategy (default: AutoSslConfiguration)
  ///
  /// Available strategies:
  /// - [DebugSslConfiguration] - Accepts all certificates (dev only)
  /// - [HardenedSslPinning] - FFI-based fingerprint validation
  /// - [AutoSslConfiguration] - Auto-selects based on build mode (recommended)
  DioFactory(
    this._talker, {
    required String baseUrl,
    bool enableLogging = false,
    SslConfiguration sslConfiguration = const AutoSslConfiguration(),
  }) : _baseUrl = baseUrl,
       _enableLogging = enableLogging,
       _sslConfiguration = sslConfiguration;

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
    final baseUrl = _baseUrl;

    final dioInstance = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );

    // Self-contained (reads only `options.extra`, no external dependencies)
    // so it's registered directly here rather than via DI, unlike
    // AuthInterceptor. Safe no-op when no trace context is set on a
    // request's `extra`.
    dioInstance.interceptors.add(TraceContextInterceptor());

    if (_enableLogging) {
      dioInstance.interceptors.add(
        TalkerDioLogger(
          talker: _talker,
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printResponseHeaders: true,
            printRequestData: true,
            printResponseData: true,
            printResponseMessage: true,
            printErrorData: true,
            printErrorHeaders: true,
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
