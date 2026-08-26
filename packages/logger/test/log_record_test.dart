// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';

void main() {
  group('LogRecord', () {
    final timestamp = DateTime.utc(2026, 1, 1, 12);

    LogRecord build({String? parentSpanId}) => LogRecord(
      module: 'wallet',
      level: LogLevel.info,
      message: 'balance refreshed',
      timestamp: timestamp,
      traceId: 'trace-1',
      spanId: 'span-1',
      parentSpanId: parentSpanId,
    );

    test('constructs with the given fields', () {
      final record = build(parentSpanId: 'span-0');

      expect(record.module, 'wallet');
      expect(record.level, LogLevel.info);
      expect(record.message, 'balance refreshed');
      expect(record.timestamp, timestamp);
      expect(record.traceId, 'trace-1');
      expect(record.spanId, 'span-1');
      expect(record.parentSpanId, 'span-0');
    });

    test('parentSpanId defaults to null for a root span', () {
      final record = build();
      expect(record.parentSpanId, isNull);
    });

    test('carries optional error and stackTrace', () {
      final error = Exception('boom');
      final stackTrace = StackTrace.current;
      final record = LogRecord(
        module: 'wallet',
        level: LogLevel.error,
        message: 'failed',
        timestamp: timestamp,
        traceId: 'trace-1',
        spanId: 'span-1',
        error: error,
        stackTrace: stackTrace,
      );

      expect(record.error, same(error));
      expect(record.stackTrace, same(stackTrace));
    });

    test('is immutable: exposes only final fields via a const constructor, '
        'and equal field values produce a structurally equal record', () {
      // Immutability itself is a compile-time guarantee here: LogRecord
      // has no setters, so `record.module = 'x'` simply does not compile.
      // As a runtime companion, verify structural (value) equality holds
      // for two independently constructed records with identical fields.
      final a = build(parentSpanId: 'span-0');
      final b = build(parentSpanId: 'span-0');

      expect(identical(a, b), isFalse);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('toString includes the key correlation fields', () {
      final record = build(parentSpanId: 'span-0');
      final text = record.toString();

      expect(text, contains('wallet'));
      expect(text, contains('trace-1'));
      expect(text, contains('span-1'));
      expect(text, contains('span-0'));
    });

    test('records with different field values are not equal', () {
      final a = build(parentSpanId: 'span-0');
      final b = LogRecord(
        module: 'wallet',
        level: LogLevel.info,
        message: 'balance refreshed',
        timestamp: timestamp,
        traceId: 'trace-1',
        spanId: 'span-2',
        parentSpanId: 'span-0',
      );

      expect(a, isNot(equals(b)));
    });
  });
}
