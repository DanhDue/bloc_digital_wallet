// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';

import 'package:bloc_digital_wallet/logging/module_gated_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';

/// `ErrorInterceptorHandler.next()` completes its (deliberately
/// `@protected`, so not directly awaitable here) internal future as an
/// *error* -- correct for Dio's real interceptor chain, where something
/// downstream always consumes it, but left dangling when the handler is
/// used standalone in a test. Runs [body] in a zone that catches that one
/// expected async error so it doesn't fail the test as "unhandled".
Future<void> _withExpectedUnhandledDioError(Future<void> Function() body) {
  final completer = Completer<void>();
  runZonedGuarded(
    () async {
      await body();
      await Future<void>.delayed(Duration.zero);
      if (!completer.isCompleted) completer.complete();
    },
    (error, stackTrace) {
      // Expected: the handler's error-completion has no other listener.
      if (!completer.isCompleted) completer.complete();
    },
  );
  return completer.future;
}

/// Spy [Interceptor] delegate recording which callbacks it received, so
/// tests can assert whether [ModuleGatedInterceptor] forwarded to it.
class _SpyInterceptor extends Interceptor {
  int onRequestCalls = 0;
  int onResponseCalls = 0;
  int onErrorCalls = 0;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    onRequestCalls++;
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    onResponseCalls++;
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    onErrorCalls++;
    handler.next(err);
  }
}

class _FakeLogManager implements ILogManager {
  final Map<String, bool> moduleToggles = <String, bool>{};

  @override
  void setModuleEnabled(String module, bool enabled) => moduleToggles[module] = enabled;

  @override
  bool isModuleEnabled(String module) => moduleToggles[module] ?? true;

  @override
  ILogger getLogger(String module) => throw UnimplementedError();

  @override
  void registerAppender(ILogAppender appender) => throw UnimplementedError();

  @override
  void log(LogRecord record) => throw UnimplementedError();

  @override
  void setAppenderEnabled(String appenderId, bool enabled) => throw UnimplementedError();
}

void main() {
  late _SpyInterceptor delegate;
  late _FakeLogManager manager;
  late ModuleGatedInterceptor interceptor;

  setUp(() {
    delegate = _SpyInterceptor();
    manager = _FakeLogManager();
    D3NexusLogger.initialize(manager);
    interceptor = ModuleGatedInterceptor(module: 'Network', delegate: delegate);
  });

  group('when the module is enabled (the default)', () {
    test('onRequest forwards to the delegate', () {
      interceptor.onRequest(RequestOptions(path: '/wallet'), RequestInterceptorHandler());
      expect(delegate.onRequestCalls, 1);
    });

    test('onResponse forwards to the delegate', () {
      final response = Response(requestOptions: RequestOptions(path: '/wallet'));
      interceptor.onResponse(response, ResponseInterceptorHandler());
      expect(delegate.onResponseCalls, 1);
    });

    test('onError forwards to the delegate', () async {
      await _withExpectedUnhandledDioError(() async {
        final err = DioException(requestOptions: RequestOptions(path: '/wallet'));
        interceptor.onError(err, ErrorInterceptorHandler());
      });
      expect(delegate.onErrorCalls, 1);
    });
  });

  group('when the module is disabled', () {
    setUp(() => manager.setModuleEnabled('Network', false));

    test('onRequest does not forward to the delegate', () {
      interceptor.onRequest(RequestOptions(path: '/wallet'), RequestInterceptorHandler());
      expect(delegate.onRequestCalls, 0);
    });

    test('onResponse does not forward to the delegate', () {
      final response = Response(requestOptions: RequestOptions(path: '/wallet'));
      interceptor.onResponse(response, ResponseInterceptorHandler());
      expect(delegate.onResponseCalls, 0);
    });

    test('onError does not forward to the delegate', () async {
      await _withExpectedUnhandledDioError(() async {
        final err = DioException(requestOptions: RequestOptions(path: '/wallet'));
        interceptor.onError(err, ErrorInterceptorHandler());
      });
      expect(delegate.onErrorCalls, 0);
    });
  });

  test('re-enabling after a disable takes effect on the very next call, live', () {
    manager.setModuleEnabled('Network', false);
    interceptor.onRequest(RequestOptions(path: '/wallet'), RequestInterceptorHandler());
    expect(delegate.onRequestCalls, 0);

    manager.setModuleEnabled('Network', true);
    interceptor.onRequest(RequestOptions(path: '/wallet'), RequestInterceptorHandler());
    expect(delegate.onRequestCalls, 1);
  });
}
