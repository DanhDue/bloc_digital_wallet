// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:core/core.dart' hide test;
import 'package:ui_kit/ui_kit.dart';
import 'package:d3_nexus_shield/app_router.dart';
import 'package:d3_nexus_shield/core/localization/app_translation_providers.dart';
import 'package:d3_nexus_shield/core/localization/multi_translation_provider.dart';
import 'package:d3_nexus_shield/di/injection.dart';
import 'package:d3_nexus_shield/shell/shell_page.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    if (!getIt.isRegistered<AppRouter>()) {
      await configureDependencies();
    }
    ColdStartProfiler.instance.enabled = true;
    ColdStartProfiler.instance.reset();
  });

  tearDown(() {
    ColdStartProfiler.instance.enabled = true;
    ColdStartProfiler.instance.reset();
  });

  group('Cold Start Telemetry Acceptance Tests', () {
    testWidgets('Full cold-start simulation records all milestones, initializers, and generates valid ASCII report', (
      tester,
    ) async {
      final profiler = ColdStartProfiler.instance;

      // 1. App entry
      profiler.start();

      // 2. Engine and binding
      profiler.mark(ColdStartMilestone.bindingInitialized);

      // 3. DI configuration
      profiler.mark(ColdStartMilestone.diStarted);
      // getIt is already configured in setUp
      profiler.mark(ColdStartMilestone.diReady);

      // 4. Core services & sub-initializers
      profiler.mark(ColdStartMilestone.coreServicesStarted);
      await ThemeManager.instance.init();
      await getIt<AppInitializer>().init();
      profiler.mark(ColdStartMilestone.coreServicesReady);

      // 5. runApp & FCP hook (mirroring main.dart)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        profiler.mark(ColdStartMilestone.firstFrameRendered);
      });
      profiler.mark(ColdStartMilestone.runAppInvoked);

      // 6. Pump widget tree and simulate first frame
      await tester.pumpWidget(
        MultiTranslationProvider(
          providers: appTranslationProviders,
          child: MaterialApp(
            theme: ThemeData(extensions: [AppThemes.light]),
            home: const ShellPage(),
          ),
        ),
      );

      // Allow post-frame callbacks and ShellPage TTI to complete
      await tester.pumpAndSettle();

      final report = profiler.report;

      // Assertions on report structure
      expect(report.records, isNotEmpty);
      expect(report.elapsedFor(ColdStartMilestone.mainEntry), isNotNull);
      expect(report.elapsedFor(ColdStartMilestone.bindingInitialized), isNotNull);
      expect(report.elapsedFor(ColdStartMilestone.diStarted), isNotNull);
      expect(report.elapsedFor(ColdStartMilestone.diReady), isNotNull);
      expect(report.elapsedFor(ColdStartMilestone.coreServicesStarted), isNotNull);
      expect(report.elapsedFor(ColdStartMilestone.coreServicesReady), isNotNull);
      expect(report.elapsedFor(ColdStartMilestone.runAppInvoked), isNotNull);
      expect(report.elapsedFor(ColdStartMilestone.firstFrameRendered), isNotNull);
      expect(report.elapsedFor(ColdStartMilestone.firstScreenInteractive), isNotNull);

      // Performance sanity bounds
      expect(report.totalToFcp.inMilliseconds, greaterThanOrEqualTo(0));
      expect(report.totalToFcp.inMilliseconds, lessThan(5000));
      expect(report.totalToTti.inMicroseconds, greaterThanOrEqualTo(report.totalToFcp.inMicroseconds));

      // Sub-initializers verification
      expect(report.subInitializersDuration.containsKey('LocalizationInitializer'), isTrue);
      expect(report.subInitializersDuration.containsKey('EnvironmentInitializer'), isTrue);
      expect(report.subInitializersDuration.containsKey('BlocObserverInitializer'), isTrue);
      expect(report.subInitializersDuration.containsKey('ImageCacheInitializer'), isTrue);
      expect(report.subInitializersDuration.containsKey('MemoryPressureObserver'), isTrue);
      expect(report.subInitializersDuration.containsKey('LoggingInitializer'), isTrue);

      // Formatted table verification
      final asciiTable = report.toFormattedAsciiTable();
      expect(asciiTable, contains('COLD START PERFORMANCE TELEMETRY REPORT'));
      expect(asciiTable, contains('1. Engine & Binding Init'));
      expect(asciiTable, contains('2. Dependency Injection (GetIt)'));
      expect(asciiTable, contains('3. Core Services & Initializers'));
      expect(asciiTable, contains('LocalizationInitializer'));
      expect(asciiTable, contains('LoggingInitializer'));
      expect(asciiTable, contains('4. Widget Tree Build (runApp)'));
      expect(asciiTable, contains('5. First Contentful Paint (FCP)'));
      expect(asciiTable, contains('6. Shell & First Screen Interactive'));
      expect(asciiTable, contains('TOTAL COLD START TIME (to FCP)'));
      expect(asciiTable, contains('TIME TO INTERACTIVE (TTI)'));
    });

    test('Idempotent finish and logReport behavior', () {
      final profiler = ColdStartProfiler.instance;
      profiler.start();
      profiler.mark(ColdStartMilestone.bindingInitialized);
      profiler.finish();

      final firstDuration = profiler.report.totalToTti;

      // Secondary finish must not crash or change state
      profiler.finish();
      expect(profiler.report.totalToTti, equals(firstDuration));

      // Secondary logReport must only log once
      int logCount = 0;
      profiler.logReport((_) => logCount++);
      profiler.logReport((_) => logCount++);
      expect(logCount, equals(1));
    });

    test('Clean reset and restart behavior', () {
      final profiler = ColdStartProfiler.instance;
      profiler.start();
      profiler.mark(ColdStartMilestone.bindingInitialized);
      profiler.finish();
      expect(profiler.report.records, isNotEmpty);

      profiler.reset();
      expect(profiler.report.records, isEmpty);
      expect(profiler.report.subInitializersDuration, isEmpty);
      expect(profiler.report.startTimestampMicros, equals(0));
      expect(profiler.report.endTimestampMicros, isNull);

      // Restart after reset
      profiler.start();
      profiler.mark(ColdStartMilestone.bindingInitialized);
      profiler.finish();
      expect(profiler.report.records.length, equals(2)); // mainEntry + bindingInitialized
    });

    test('Disabled profiler produces empty telemetry without overhead', () async {
      final profiler = ColdStartProfiler.instance;
      profiler.enabled = false;

      profiler.start();
      profiler.mark(ColdStartMilestone.bindingInitialized);
      final syncResult = profiler.timeSync('testSync', () => 42);
      final asyncResult = await profiler.timeAsync('testAsync', () async => 'ok');
      profiler.finish();

      int logCount = 0;
      profiler.logReport((_) => logCount++);

      expect(syncResult, equals(42));
      expect(asyncResult, equals('ok'));
      expect(logCount, equals(0));
      expect(profiler.report.records, isEmpty);
      expect(profiler.report.subInitializersDuration, isEmpty);
    });
  });
}
