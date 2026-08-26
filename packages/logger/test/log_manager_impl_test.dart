// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';

import 'support/fake_logging.dart';

void main() {
  late LogManagerImpl manager;

  setUp(() {
    manager = LogManagerImpl();
  });

  LogRecord buildRecord({String module = 'wallet'}) => LogRecord(
    module: module,
    level: LogLevel.info,
    message: 'balance refreshed',
    timestamp: DateTime.utc(2026, 1, 1, 12),
    traceId: 'trace-1',
    spanId: 'span-1',
  );

  group('dispatch matrix', () {
    test('appender disabled by setAppenderEnabled is skipped regardless of '
        'module toggle', () {
      final appender = FakeAppender('console');
      manager.registerAppender(appender);
      manager.setAppenderEnabled('console', false);
      // Module left enabled (default) — appender toggle alone must skip.
      manager.setModuleEnabled('wallet', true);

      manager.log(buildRecord());

      expect(appender.received, isEmpty);
    });

    test('appender disabled by setAppenderEnabled is skipped even when the '
        'module is also disabled', () {
      final appender = FakeAppender('console');
      manager.registerAppender(appender);
      manager.setAppenderEnabled('console', false);
      manager.setModuleEnabled('wallet', false);

      manager.log(buildRecord());

      expect(appender.received, isEmpty);
    });

    test('appender enabled + module disabled + respectsModuleToggle=true is '
        'skipped (soft mute honored)', () {
      final appender = FakeAppender('console', respectsModuleToggle: true);
      manager.registerAppender(appender);
      manager.setModuleEnabled('wallet', false);

      manager.log(buildRecord());

      expect(appender.received, isEmpty);
    });

    test('appender enabled + module disabled + respectsModuleToggle=false is '
        'still dispatched (appender opts out of module muting)', () {
      final appender = FakeAppender('datadog', respectsModuleToggle: false);
      manager.registerAppender(appender);
      manager.setModuleEnabled('wallet', false);

      final record = buildRecord();
      manager.log(record);

      expect(appender.received, [record]);
    });

    test('appender enabled + module enabled dispatches the record', () {
      final appender = FakeAppender('console');
      manager.registerAppender(appender);
      manager.setModuleEnabled('wallet', true);

      final record = buildRecord();
      manager.log(record);

      expect(appender.received, [record]);
    });

    test('module toggle defaults to enabled when never set', () {
      final appender = FakeAppender('console');
      manager.registerAppender(appender);

      final record = buildRecord();
      manager.log(record);

      expect(appender.received, [record]);
    });

    test('appender toggle defaults to enabled when never set', () {
      final appender = FakeAppender('console');
      manager.registerAppender(appender);

      final record = buildRecord();
      manager.log(record);

      expect(appender.received, [record]);
    });

    test('dispatches to every registered appender independently', () {
      final talker = FakeAppender('talker', respectsModuleToggle: true);
      final datadog = FakeAppender('datadog', respectsModuleToggle: false);
      manager.registerAppender(talker);
      manager.registerAppender(datadog);
      manager.setModuleEnabled('wallet', false);

      final record = buildRecord();
      manager.log(record);

      expect(talker.received, isEmpty);
      expect(datadog.received, [record]);
    });

    test('re-enabling a disabled appender resumes dispatch', () {
      final appender = FakeAppender('console');
      manager.registerAppender(appender);
      manager.setAppenderEnabled('console', false);
      manager.log(buildRecord());
      expect(appender.received, isEmpty);

      manager.setAppenderEnabled('console', true);
      final record = buildRecord();
      manager.log(record);

      expect(appender.received, [record]);
    });
  });

  group('getLogger', () {
    test('returns an ILogger for the module', () {
      expect(manager.getLogger('wallet'), isA<ILogger>());
    });

    test('returns the same logical logger for repeated calls with the same '
        'module', () {
      final first = manager.getLogger('wallet');
      final second = manager.getLogger('wallet');

      expect(first, same(second));
    });

    test('returns a distinct logger per module', () {
      final wallet = manager.getLogger('wallet');
      final scanner = manager.getLogger('scanner');

      expect(wallet, isNot(same(scanner)));
    });

    test('loggers obtained from getLogger route through this manager on '
        'log calls', () {
      final appender = FakeAppender('console');
      manager.registerAppender(appender);

      manager.getLogger('wallet').i('hello');

      expect(appender.received, hasLength(1));
      expect(appender.received.single.message, 'hello');
      expect(appender.received.single.module, 'wallet');
    });
  });

  group('isModuleEnabled', () {
    test('a module never toggled defaults to enabled', () {
      expect(manager.isModuleEnabled('wallet'), isTrue);
    });

    test('reflects the current value immediately after setModuleEnabled(false)', () {
      manager.setModuleEnabled('wallet', false);
      expect(manager.isModuleEnabled('wallet'), isFalse);
    });

    test('reflects a value flipped back to true, live, with no restart concept involved', () {
      manager.setModuleEnabled('wallet', false);
      expect(manager.isModuleEnabled('wallet'), isFalse);

      manager.setModuleEnabled('wallet', true);
      expect(manager.isModuleEnabled('wallet'), isTrue);
    });

    test('toggling one module does not affect another', () {
      manager.setModuleEnabled('wallet', false);
      expect(manager.isModuleEnabled('network'), isTrue);
    });
  });
}
