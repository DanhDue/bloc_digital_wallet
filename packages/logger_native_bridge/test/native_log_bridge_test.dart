// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';
import 'package:logger_native_bridge/logger_native_bridge.dart';

import 'support/fake_logging.dart';

void main() {
  late FakeLogManager manager;
  late NativeLogBridge bridge;

  setUp(() {
    manager = FakeLogManager();
    D3NexusLogger.initialize(manager);
    bridge = NativeLogBridge();
  });

  NativeLogMessage buildMessage({
    NativeLogLevel level = NativeLogLevel.info,
    String tag = 'Wallet',
    String message = 'hello from native',
    int timestamp = 1_700_000_000_000,
    String? traceId,
  }) {
    return NativeLogMessage(
      level: level,
      tag: tag,
      message: message,
      timestamp: timestamp,
      traceId: traceId,
    );
  }

  test('forwards into D3NexusLogger.getLogger with the Native:<tag> module name', () {
    bridge.onNativeLog(buildMessage(tag: 'Wallet'));

    final logger = D3NexusLogger.getLogger('Native:Wallet') as FakeLogger;
    expect(logger.records, hasLength(1));
  });

  test('different native tags map to distinct Native:<tag> loggers', () {
    bridge.onNativeLog(buildMessage(tag: 'Wallet'));
    bridge.onNativeLog(buildMessage(tag: 'Scanner'));

    final wallet = D3NexusLogger.getLogger('Native:Wallet') as FakeLogger;
    final scanner = D3NexusLogger.getLogger('Native:Scanner') as FakeLogger;
    expect(wallet.records, hasLength(1));
    expect(scanner.records, hasLength(1));
  });

  group('level mapping', () {
    test('NativeLogLevel.verbose maps to LogLevel.verbose', () {
      bridge.onNativeLog(buildMessage(level: NativeLogLevel.verbose));
      final record = (D3NexusLogger.getLogger('Native:Wallet') as FakeLogger).records.single;
      expect(record.level, LogLevel.verbose);
    });

    test('NativeLogLevel.debug maps to LogLevel.debug', () {
      bridge.onNativeLog(buildMessage(level: NativeLogLevel.debug));
      final record = (D3NexusLogger.getLogger('Native:Wallet') as FakeLogger).records.single;
      expect(record.level, LogLevel.debug);
    });

    test('NativeLogLevel.info maps to LogLevel.info', () {
      bridge.onNativeLog(buildMessage(level: NativeLogLevel.info));
      final record = (D3NexusLogger.getLogger('Native:Wallet') as FakeLogger).records.single;
      expect(record.level, LogLevel.info);
    });

    test('NativeLogLevel.warning maps to LogLevel.warning', () {
      bridge.onNativeLog(buildMessage(level: NativeLogLevel.warning));
      final record = (D3NexusLogger.getLogger('Native:Wallet') as FakeLogger).records.single;
      expect(record.level, LogLevel.warning);
    });

    test('NativeLogLevel.error maps to LogLevel.error', () {
      bridge.onNativeLog(buildMessage(level: NativeLogLevel.error));
      final record = (D3NexusLogger.getLogger('Native:Wallet') as FakeLogger).records.single;
      expect(record.level, LogLevel.error);
    });
  });

  test('forwarded message text contains the original message content', () {
    bridge.onNativeLog(buildMessage(message: 'headless push happened'));

    final record = (D3NexusLogger.getLogger('Native:Wallet') as FakeLogger).records.single;
    expect(record.message, contains('headless push happened'));
  });

  test(
    'forwarded message text preserves the ORIGINAL native timestamp, not '
    'replay time (known gap: LogRecord.timestamp itself is replay time -- '
    'see NativeLogBridge doc comment)',
    () {
      final originalTimestampMillis = 1_700_000_000_000;
      bridge.onNativeLog(buildMessage(timestamp: originalTimestampMillis));

      final record = (D3NexusLogger.getLogger('Native:Wallet') as FakeLogger).records.single;
      final expectedIso = DateTime.fromMillisecondsSinceEpoch(
        originalTimestampMillis,
        isUtc: true,
      ).toIso8601String();

      expect(record.message, contains(expectedIso));
      // The known gap, made explicit: LogRecord.timestamp is replay time,
      // not the original native timestamp (LoggerImpl always stamps
      // DateTime.now() -- see packages/logger/lib/src/logger_impl.dart).
      expect(
        record.timestamp.millisecondsSinceEpoch,
        isNot(originalTimestampMillis),
      );
    },
  );

  test('replays multiple entries in call order (FIFO), matching NativeLogBridgePlugin replay order', () {
    bridge.onNativeLog(buildMessage(message: 'first'));
    bridge.onNativeLog(buildMessage(message: 'second'));
    bridge.onNativeLog(buildMessage(message: 'third'));

    final records = (D3NexusLogger.getLogger('Native:Wallet') as FakeLogger).records;
    expect(records.map((r) => r.message), [
      contains('first'),
      contains('second'),
      contains('third'),
    ]);
  });
}
