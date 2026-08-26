// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_digital_wallet/logging/appenders/talker_appender.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:talker_flutter/talker_flutter.dart' hide LogLevel;
import 'package:talker_flutter/talker_flutter.dart' as talker_pkg show LogLevel;

import 'talker_appender_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Talker>(unsupportedMembers: {#configure})])
void main() {
  late MockTalker talker;
  late TalkerAppender appender;

  setUp(() {
    talker = MockTalker();
    appender = TalkerAppender(talker);
  });

  LogRecord recordWith(
    LogLevel level, {
    String module = 'Wallet',
    Object? error,
    StackTrace? stackTrace,
  }) {
    return LogRecord(
      module: module,
      level: level,
      message: 'hello world',
      timestamp: DateTime(2026, 1, 1),
      traceId: '0123456789abcdef0123456789abcdef',
      spanId: '0123456789abcdef',
      error: error,
      stackTrace: stackTrace,
    );
  }

  TalkerLog captureLoggedEntry() {
    final captured = verify(talker.logCustom(captureAny)).captured;
    expect(captured, hasLength(1));
    return captured.single as TalkerLog;
  }

  test('id is talker', () {
    expect(appender.id, 'talker');
  });

  test('respectsModuleToggle is true', () {
    expect(appender.respectsModuleToggle, isTrue);
  });

  test('append tags the Talker entry title with the record module, so Talker\'s '
      'own filter chips become per-module (Talker filters by entry title)', () {
    appender.append(recordWith(LogLevel.info, module: 'Network'));
    final entry = captureLoggedEntry();
    expect(entry.title, 'Network');
  });

  test('append maps every LogLevel to the matching talker LogLevel', () {
    final expectedMapping = {
      LogLevel.verbose: talker_pkg.LogLevel.verbose,
      LogLevel.debug: talker_pkg.LogLevel.debug,
      LogLevel.info: talker_pkg.LogLevel.info,
      LogLevel.warning: talker_pkg.LogLevel.warning,
      LogLevel.error: talker_pkg.LogLevel.error,
    };

    for (final entry in expectedMapping.entries) {
      final freshTalker = MockTalker();
      final freshAppender = TalkerAppender(freshTalker);
      freshAppender.append(recordWith(entry.key));
      final captured = verify(freshTalker.logCustom(captureAny)).captured;
      final loggedEntry = captured.single as TalkerLog;
      expect(loggedEntry.logLevel, entry.value, reason: 'for ${entry.key}');
    }
  });

  test('append forwards the message', () {
    appender.append(recordWith(LogLevel.info));
    final entry = captureLoggedEntry();
    expect(entry.message, 'hello world');
  });

  test('append forwards error records, including error and stackTrace', () {
    final error = Exception('boom');
    final stackTrace = StackTrace.current;
    appender.append(recordWith(LogLevel.error, error: error, stackTrace: stackTrace));
    final entry = captureLoggedEntry();
    expect(entry.exception, error);
    expect(entry.stackTrace, stackTrace);
  });

  test('append omits exception/stackTrace when the record has none', () {
    appender.append(recordWith(LogLevel.debug));
    final entry = captureLoggedEntry();
    expect(entry.exception, isNull);
    expect(entry.stackTrace, isNull);
  });
}
