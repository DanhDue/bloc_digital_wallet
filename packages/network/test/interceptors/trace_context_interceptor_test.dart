// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';
import 'package:network/interceptors/trace_context_interceptor.dart';

/// Minimal [ILogger] test double exposing fixed [traceId]/[spanId] so the
/// interceptor's header-building logic can be asserted deterministically,
/// independent of `packages/logger`'s real id generation.
class _FakeTraceLogger implements ILogger {
  _FakeTraceLogger({required this.traceId, required this.spanId});

  @override
  final String traceId;

  @override
  final String spanId;

  @override
  void d(String message, {Object? error, StackTrace? stackTrace}) {}

  @override
  void i(String message, {Object? error, StackTrace? stackTrace}) {}

  @override
  void w(String message, {Object? error, StackTrace? stackTrace}) {}

  @override
  void e(String message, {Object? error, StackTrace? stackTrace}) {}

  @override
  void v(String message, {Object? error, StackTrace? stackTrace}) {}

  @override
  ILogger withSpan() => this;
}

void main() {
  group('TraceContextInterceptor', () {
    test(
      'adds a W3C-formatted traceparent header when extra["d3nexusLogger"] '
      'holds an active ILogger',
      () {
        final logger = _FakeTraceLogger(
          traceId: '0af7651916cd43dd8448eb211c80319c',
          spanId: 'b7ad6b7169203331',
        );
        final options = RequestOptions(
          path: '/wallet',
          extra: {'d3nexusLogger': logger},
        );
        final interceptor = TraceContextInterceptor();

        interceptor.onRequest(options, RequestInterceptorHandler());

        expect(
          options.headers['traceparent'],
          '00-0af7651916cd43dd8448eb211c80319c-b7ad6b7169203331-01',
        );
      },
    );

    test(
      'does not add a traceparent header when extra["d3nexusLogger"] is '
      'absent',
      () {
        final options = RequestOptions(path: '/wallet');
        final interceptor = TraceContextInterceptor();

        interceptor.onRequest(options, RequestInterceptorHandler());

        expect(options.headers.containsKey('traceparent'), isFalse);
      },
    );

    test(
      'does not add a traceparent header when extra["d3nexusLogger"] is '
      'present but not an ILogger',
      () {
        final options = RequestOptions(
          path: '/wallet',
          extra: {'d3nexusLogger': 'not-a-logger'},
        );
        final interceptor = TraceContextInterceptor();

        interceptor.onRequest(options, RequestInterceptorHandler());

        expect(options.headers.containsKey('traceparent'), isFalse);
      },
    );
  });
}
