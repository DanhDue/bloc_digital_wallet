// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/telemetry/cold_start_milestone.dart';
import 'package:core/telemetry/cold_start_profiler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ColdStartProfiler Tests', () {
    late ColdStartProfiler profiler;

    setUp(() {
      profiler = ColdStartProfiler.instance;
      profiler.enabled = true;
      profiler.reset();
    });

    tearDown(() {
      profiler.reset();
    });

    test('start and mark records milestones in chronological order', () async {
      profiler.start();
      await Future<void>.delayed(const Duration(milliseconds: 10));
      profiler.mark(ColdStartMilestone.bindingInitialized);
      await Future<void>.delayed(const Duration(milliseconds: 15));
      profiler.mark(ColdStartMilestone.diReady);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      profiler.mark(ColdStartMilestone.firstFrameRendered);
      profiler.finish();

      final report = profiler.report;
      expect(report.records.length, greaterThanOrEqualTo(4));
      expect(report.records.first.milestone, equals(ColdStartMilestone.mainEntry));
      expect(report.totalToFcp.inMilliseconds, greaterThanOrEqualTo(30));

      for (int i = 1; i < report.records.length; i++) {
        expect(
          report.records[i].elapsedMicrosSinceStart,
          greaterThanOrEqualTo(report.records[i - 1].elapsedMicrosSinceStart),
        );
      }
    });

    test('timeSync captures synchronous block execution duration', () {
      profiler.start();
      final result = profiler.timeSync('sync_test_task', () {
        var sum = 0;
        for (var i = 0; i < 1000; i++) {
          sum += i;
        }
        return sum;
      });

      expect(result, equals(499500));
      final report = profiler.report;
      expect(report.subInitializersDuration.containsKey('sync_test_task'), isTrue);
      expect(report.subInitializersDuration['sync_test_task']!.inMicroseconds, greaterThan(0));
    });

    test('timeAsync captures async block duration and handles failures gracefully', () async {
      profiler.start();

      final asyncResult = await profiler.timeAsync('async_success_task', () async {
        await Future<void>.delayed(const Duration(milliseconds: 15));
        return 'success';
      });
      expect(asyncResult, equals('success'));

      await expectLater(
        profiler.timeAsync<void>('async_fail_task', () async {
          await Future<void>.delayed(const Duration(milliseconds: 5));
          throw Exception('test error');
        }),
        throwsException,
      );

      final report = profiler.report;
      expect(report.subInitializersDuration.containsKey('async_success_task'), isTrue);
      expect(
        report.subInitializersDuration['async_success_task']!.inMilliseconds,
        greaterThanOrEqualTo(10),
      );
      expect(report.subInitializersDuration.containsKey('async_fail_task'), isTrue);
    });

    test('toFormattedAsciiTable generates expected structured table', () {
      profiler.start();
      profiler.mark(ColdStartMilestone.bindingInitialized);
      profiler.mark(ColdStartMilestone.diStarted);
      profiler.mark(ColdStartMilestone.diReady);
      profiler.mark(ColdStartMilestone.coreServicesStarted);
      profiler.timeSync('MockInit', () {});
      profiler.mark(ColdStartMilestone.coreServicesReady);
      profiler.mark(ColdStartMilestone.runAppInvoked);
      profiler.mark(ColdStartMilestone.firstFrameRendered);
      profiler.mark(ColdStartMilestone.firstScreenInteractive);
      profiler.finish();

      final report = profiler.report;
      final table = report.toFormattedAsciiTable();

      expect(table, contains('COLD START PERFORMANCE TELEMETRY REPORT'));
      expect(table, contains('Engine & Binding Init'));
      expect(table, contains('Dependency Injection (GetIt)'));
      expect(table, contains('Core Services & Initializers'));
      expect(table, contains('MockInit'));
      expect(table, contains('TOTAL COLD START TIME (to FCP)'));
      expect(table, contains('TIME TO INTERACTIVE (TTI)'));
    });

    test('disabled profiler passes through without tracking or overhead', () async {
      profiler.enabled = false;
      profiler.start();
      profiler.mark(ColdStartMilestone.bindingInitialized);

      final syncVal = profiler.timeSync('sync_pass', () => 42);
      expect(syncVal, equals(42));

      final asyncVal = await profiler.timeAsync('async_pass', () async => 'ok');
      expect(asyncVal, equals('ok'));

      profiler.finish();

      final report = profiler.report;
      expect(report.records, isEmpty);
      expect(report.subInitializersDuration, isEmpty);
      expect(report.totalToFcp, equals(Duration.zero));
    });
  });
}
