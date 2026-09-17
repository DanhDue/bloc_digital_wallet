// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/telemetry/cold_start_log.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() {
  group('ColdStartLog Tests', () {
    test('has title ColdStartProfiler and key cold_start_profiler', () {
      final log = ColdStartLog('test cold start message');

      expect(log, isA<TalkerLog>());
      expect(log.title, equals('ColdStartProfiler'));
      expect(log.key, equals('cold_start_profiler'));
      expect(ColdStartLog.getKey, equals('cold_start_profiler'));
      expect(log.message, equals('test cold start message'));
      expect(log.pen, isNotNull);
      expect(ColdStartLog.getPen, isNotNull);
    });
  });
}
