// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';

import 'support/fake_logging.dart';

void main() {
  late LogManagerImpl manager;
  late FakeAppender appender;

  setUp(() {
    manager = LogManagerImpl();
    appender = FakeAppender('console');
    manager.registerAppender(appender);
  });

  group('LoggerImpl level methods', () {
    test('d() builds and dispatches a debug-level record', () {
      manager.getLogger('wallet').d('debug msg');

      expect(appender.received.single.level, LogLevel.debug);
      expect(appender.received.single.message, 'debug msg');
    });

    test('i() builds and dispatches an info-level record', () {
      manager.getLogger('wallet').i('info msg');

      expect(appender.received.single.level, LogLevel.info);
    });

    test('w() builds and dispatches a warning-level record', () {
      manager.getLogger('wallet').w('warn msg');

      expect(appender.received.single.level, LogLevel.warning);
    });

    test('e() builds and dispatches an error-level record, carrying error '
        'and stackTrace', () {
      final error = Exception('boom');
      final stackTrace = StackTrace.current;

      manager.getLogger('wallet').e('error msg', error: error, stackTrace: stackTrace);

      final record = appender.received.single;
      expect(record.level, LogLevel.error);
      expect(record.error, error);
      expect(record.stackTrace, stackTrace);
    });

    test('v() builds and dispatches a verbose-level record', () {
      manager.getLogger('wallet').v('verbose msg');

      expect(appender.received.single.level, LogLevel.verbose);
    });

    test('every emitted record carries the logger\'s module', () {
      manager.getLogger('scanner').i('event');

      expect(appender.received.single.module, 'scanner');
    });
  });

  group('trace/span id generation', () {
    test('a fresh logger from getLogger has a root span (no parentSpanId)', () {
      manager.getLogger('wallet').i('event');

      expect(appender.received.single.parentSpanId, isNull);
    });

    test('generated traceId is 32 hex chars and spanId is 16 hex chars, '
        'per the W3C Trace Context trace-id/parent-id lengths', () {
      final logger = manager.getLogger('wallet');

      expect(logger.traceId, hasLength(32));
      expect(logger.traceId, matches(RegExp(r'^[0-9a-f]{32}$')));
      expect(logger.spanId, hasLength(16));
      expect(logger.spanId, matches(RegExp(r'^[0-9a-f]{16}$')));
    });

    test('two loggers for different modules get distinct traceIds', () {
      manager.getLogger('wallet').i('a');
      manager.getLogger('scanner').i('b');

      final traceIds = appender.received.map((r) => r.traceId).toSet();
      expect(traceIds, hasLength(2));
    });

    test('withSpan stamps a fresh spanId, keeps the same traceId, and sets '
        'parentSpanId to the parent span', () {
      final root = manager.getLogger('wallet');
      root.i('root event');
      final child = root.withSpan();
      child.i('child event');

      final rootRecord = appender.received[0];
      final childRecord = appender.received[1];

      expect(childRecord.traceId, rootRecord.traceId);
      expect(childRecord.spanId, isNot(rootRecord.spanId));
      expect(childRecord.parentSpanId, rootRecord.spanId);
    });

    test('withSpan chains produce a deeper lineage with a shared traceId', () {
      final root = manager.getLogger('wallet');
      final child = root.withSpan();
      final grandchild = child.withSpan();

      root.i('r');
      child.i('c');
      grandchild.i('g');

      final records = appender.received;
      expect(records.every((r) => r.traceId == records.first.traceId), isTrue);
      expect(records[2].parentSpanId, records[1].spanId);
      expect(records[1].parentSpanId, records[0].spanId);
    });
  });
}
