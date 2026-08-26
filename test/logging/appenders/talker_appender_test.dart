// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_digital_wallet/logging/appenders/talker_appender.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:talker_flutter/talker_flutter.dart' hide LogLevel;

import 'talker_appender_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Talker>(unsupportedMembers: {#configure})])
void main() {
  late MockTalker talker;
  late TalkerAppender appender;

  setUp(() {
    talker = MockTalker();
    appender = TalkerAppender(talker);
  });

  LogRecord recordWith(LogLevel level, {Object? error, StackTrace? stackTrace}) {
    return LogRecord(
      module: 'wallet',
      level: level,
      message: 'hello world',
      timestamp: DateTime(2026, 1, 1),
      traceId: '0123456789abcdef0123456789abcdef',
      spanId: '0123456789abcdef',
      error: error,
      stackTrace: stackTrace,
    );
  }

  test('id is talker', () {
    expect(appender.id, 'talker');
  });

  test('respectsModuleToggle is true', () {
    expect(appender.respectsModuleToggle, isTrue);
  });

  test('append forwards verbose records to Talker.verbose', () {
    appender.append(recordWith(LogLevel.verbose));
    verify(talker.verbose('hello world', null, null)).called(1);
  });

  test('append forwards debug records to Talker.debug', () {
    appender.append(recordWith(LogLevel.debug));
    verify(talker.debug('hello world', null, null)).called(1);
  });

  test('append forwards info records to Talker.info', () {
    appender.append(recordWith(LogLevel.info));
    verify(talker.info('hello world', null, null)).called(1);
  });

  test('append forwards warning records to Talker.warning', () {
    appender.append(recordWith(LogLevel.warning));
    verify(talker.warning('hello world', null, null)).called(1);
  });

  test('append forwards error records, including error and stackTrace, to Talker.error', () {
    final error = Exception('boom');
    final stackTrace = StackTrace.current;
    appender.append(recordWith(LogLevel.error, error: error, stackTrace: stackTrace));
    verify(talker.error('hello world', error, stackTrace)).called(1);
  });
}
