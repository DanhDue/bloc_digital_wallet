// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:d3_nexus_shield/logging/appenders/otel_appender.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'otel_appender_test.mocks.dart';

@GenerateMocks([OtelSpanClient])
void main() {
  late MockOtelSpanClient client;
  late OtelAppender appender;

  setUp(() {
    client = MockOtelSpanClient();
    appender = OtelAppender(client);
  });

  LogRecord recordWith(LogLevel level, {Object? error}) {
    return LogRecord(
      module: 'wallet',
      level: level,
      message: 'hello world',
      timestamp: DateTime(2026, 1, 1),
      traceId: '0123456789abcdef0123456789abcdef',
      spanId: '0123456789abcdef',
      parentSpanId: 'fedcba9876543210',
      error: error,
    );
  }

  test('id is otel', () {
    expect(appender.id, 'otel');
  });

  test('respectsModuleToggle is false', () {
    expect(appender.respectsModuleToggle, isFalse);
  });

  test('append calls recordSpanEvent with traceId/spanId/parentSpanId mapped correctly', () {
    appender.append(recordWith(LogLevel.info));

    verify(
      client.recordSpanEvent(
        traceId: '0123456789abcdef0123456789abcdef',
        spanId: '0123456789abcdef',
        parentSpanId: 'fedcba9876543210',
        name: 'hello world',
        severity: 'info',
        attributes: {'module': 'wallet'},
      ),
    ).called(1);
  });

  test('append includes error in attributes when present', () {
    final error = Exception('boom');
    appender.append(recordWith(LogLevel.error, error: error));

    final captured = verify(
      client.recordSpanEvent(
        traceId: anyNamed('traceId'),
        spanId: anyNamed('spanId'),
        parentSpanId: anyNamed('parentSpanId'),
        name: anyNamed('name'),
        severity: anyNamed('severity'),
        attributes: captureAnyNamed('attributes'),
      ),
    ).captured;

    final attributes = captured.single as Map<String, String>;
    expect(attributes['error'], error.toString());
  });
}
