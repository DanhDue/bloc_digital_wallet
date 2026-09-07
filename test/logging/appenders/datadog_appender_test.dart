// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:d3_nexus_shield/logging/appenders/datadog_appender.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'datadog_appender_test.mocks.dart';

@GenerateMocks([DatadogLogClient])
void main() {
  late MockDatadogLogClient client;
  late DatadogAppender appender;

  setUp(() {
    client = MockDatadogLogClient();
    appender = DatadogAppender(client);
  });

  LogRecord recordWith(LogLevel level, {Object? error, StackTrace? stackTrace}) {
    return LogRecord(
      module: 'wallet',
      level: level,
      message: 'hello world',
      timestamp: DateTime(2026, 1, 1),
      traceId: '0123456789abcdef0123456789abcdef',
      spanId: '0123456789abcdef',
      parentSpanId: 'fedcba9876543210',
      error: error,
      stackTrace: stackTrace,
    );
  }

  test('id is datadog', () {
    expect(appender.id, 'datadog');
  });

  test('respectsModuleToggle is false', () {
    expect(appender.respectsModuleToggle, isFalse);
  });

  test('append calls the client log method with mapped status and correlation ids', () {
    appender.append(recordWith(LogLevel.warning));

    final captured = verify(
      client.log(
        captureAny,
        status: captureAnyNamed('status'),
        attributes: captureAnyNamed('attributes'),
      ),
    ).captured;

    expect(captured[0], 'hello world');
    expect(captured[1], 'warn');
    final attributes = captured[2] as Map<String, Object?>;
    expect(attributes['module'], 'wallet');
    expect(attributes['traceId'], '0123456789abcdef0123456789abcdef');
    expect(attributes['spanId'], '0123456789abcdef');
    expect(attributes['parentSpanId'], 'fedcba9876543210');
  });

  test('append maps every LogLevel to a Datadog status', () {
    const expected = {
      LogLevel.verbose: 'trace',
      LogLevel.debug: 'debug',
      LogLevel.info: 'info',
      LogLevel.warning: 'warn',
      LogLevel.error: 'error',
    };

    for (final entry in expected.entries) {
      appender.append(recordWith(entry.key));
      verify(client.log(any, status: entry.value, attributes: anyNamed('attributes'))).called(1);
    }
  });

  test('append includes error and stackTrace in attributes when present', () {
    final error = Exception('boom');
    final stackTrace = StackTrace.current;
    appender.append(recordWith(LogLevel.error, error: error, stackTrace: stackTrace));

    final captured = verify(
      client.log(any, status: anyNamed('status'), attributes: captureAnyNamed('attributes')),
    ).captured;
    final attributes = captured.single as Map<String, Object?>;
    expect(attributes['error'], error.toString());
    expect(attributes['stackTrace'], stackTrace.toString());
  });
}
