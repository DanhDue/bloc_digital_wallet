// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';

import 'support/fake_logging.dart';

void main() {
  late FakeLogManager manager;

  setUp(() {
    manager = FakeLogManager();
    D3NexusLogger.initialize(manager);
  });

  group('getLogger', () {
    test('returns a distinct logger per module', () {
      final wallet = D3NexusLogger.getLogger('wallet');
      final scanner = D3NexusLogger.getLogger('scanner');

      expect(wallet, isNot(same(scanner)));
    });

    test('returns the same logical logger for repeated calls with the same '
        'module', () {
      final first = D3NexusLogger.getLogger('wallet');
      final second = D3NexusLogger.getLogger('wallet');

      expect(first, same(second));
    });

    test('delegates to the ILogManager supplied via initialize', () {
      D3NexusLogger.getLogger('wallet');

      expect(manager.getLogger('wallet'), isNotNull);
    });
  });

  group('withSpan', () {
    test('stamps a new spanId on the returned logger, with parentSpanId set '
        'to the current span', () {
      final logger = D3NexusLogger.getLogger('wallet') as FakeLogger;
      final child = logger.withSpan() as FakeLogger;

      expect(child.spanId, isNot(logger.spanId));
      expect(child.parentSpanId, logger.spanId);
    });

    test('records emitted after withSpan carry the child span correlation', () {
      final logger = D3NexusLogger.getLogger('wallet') as FakeLogger;
      final child = logger.withSpan() as FakeLogger;

      child.i('child event');

      final record = child.records.single;
      expect(record.traceId, logger.traceId);
      expect(record.spanId, child.spanId);
      expect(record.parentSpanId, logger.spanId);
    });

    test('withSpan can be chained to build a deeper span lineage', () {
      final root = D3NexusLogger.getLogger('wallet') as FakeLogger;
      final grandchild = root.withSpan().withSpan() as FakeLogger;

      grandchild.d('deep event');

      final record = grandchild.records.single;
      expect(record.parentSpanId, isNot(root.spanId));
      expect(record.parentSpanId, isNot(record.spanId));
    });
  });

  test('appenders registered on the manager are retained', () {
    final appender = FakeAppender('console');

    manager.registerAppender(appender);

    expect(manager.appenders, contains(appender));
  });
}
