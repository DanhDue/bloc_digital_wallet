// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_digital_wallet/logging/appenders/datadog_appender.dart';
import 'package:bloc_digital_wallet/logging/appenders/otel_appender.dart';
import 'package:bloc_digital_wallet/logging/appenders/talker_appender.dart';
import 'package:bloc_digital_wallet/logging/appenders_for_environment.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:talker_flutter/talker_flutter.dart' hide LogLevel;

import 'appenders_for_environment_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Talker>(unsupportedMembers: {#configure}),
])
void main() {
  late MockTalker talker;

  setUp(() {
    talker = MockTalker();
  });

  test('development registers only the Talker appender', () {
    final appenders = appendersForEnvironment(talker, isDevelopment: true);

    expect(appenders, hasLength(1));
    expect(appenders.single, isA<TalkerAppender>());
  });

  test('staging/production registers Talker, Datadog, and Otel appenders', () {
    final appenders = appendersForEnvironment(talker, isDevelopment: false);

    expect(appenders, hasLength(3));
    expect(appenders.whereType<TalkerAppender>(), hasLength(1));
    expect(appenders.whereType<DatadogAppender>(), hasLength(1));
    expect(appenders.whereType<OtelAppender>(), hasLength(1));
  });

  test('non-development appender set has the correct module-toggle semantics', () {
    final appenders = appendersForEnvironment(talker, isDevelopment: false);

    for (final appender in appenders) {
      if (appender is TalkerAppender) {
        expect(appender.respectsModuleToggle, isTrue);
      } else {
        expect(appender.respectsModuleToggle, isFalse);
      }
    }
  });
}
