// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'interceptors/trace_context_interceptor.dart';
import 'ssl/ssl.dart';

class DioFactory {
  final Talker _talker;
  final SslConfiguration _sslConfiguration;

  Duration _connectTimeout = const Duration(seconds: 30);
  Duration _receiveTimeout = const Duration(seconds: 30);

  final String _baseUrl;

  /// Creates a DioFactory with optional SSL configuration.
  ///
  /// [talker] - Logger instance for debugging
  /// [baseUrl] - The base URL for the API
  /// [enableLogging] - Unused here; TalkerDioLogger registration now lives
  /// in the app layer (see `lib/di/app_network_module.dart`), gated on
  /// `core.EnvironmentConfig.enableLogging` directly. Kept as a parameter
  /// for API stability with existing callers (e.g. `NetworkModule`).
  /// [sslConfiguration] - SSL pinning strategy (default: AutoSslConfiguration)
  ///
  /// Available strategies:
  /// - [DebugSslConfiguration] - Accepts all certificates (dev only)
  /// - [HardenedSslPinning] - FFI-based fingerprint validation
  /// - [AutoSslConfiguration] - Auto-selects based on build mode (recommended)
  DioFactory(
    this._talker, {
    required String baseUrl,
    // ignore: avoid_unused_constructor_parameters
    bool enableLogging = false,
    SslConfiguration sslConfiguration = const AutoSslConfiguration(),
  }) : _baseUrl = baseUrl,
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

    // TalkerDioLogger is added from the app layer (see
    // lib/di/app_network_module.dart), not here, per the logging-refactor
    // epic's Phase 4 (move talker_dio_logger out of packages/network into
    // the app-layer appenders).

    // AuthInterceptor is added via Dependency Injection in NetworkModule

    // Apply SSL configuration strategy
    _sslConfiguration.configure(dioInstance, _talker);

    return dioInstance;
  }
}
