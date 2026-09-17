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

import 'package:d3_nexus_shield/shell/home_dashboard_page.dart';
import 'package:scanner/scanner.dart';
import 'package:settings/settings.dart';
import 'package:d3_nexus_shield/shell/shell_bloc.dart';
import 'package:d3_nexus_shield/shell/shell_action.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    if (!getIt.isRegistered<AppRouter>()) {
      await configureDependencies();
    }
    ColdStartProfiler.instance.reset();
  });

  tearDown(() async {
    ColdStartProfiler.instance.reset();
    await getIt.reset();
  });

  testWidgets('ShellPage post-frame records firstScreenInteractive and finishes profiler', (
    tester,
  ) async {
    ColdStartProfiler.instance.start();

    await ThemeManager.instance.init();
    await getIt<AppInitializer>().init();

    await tester.pumpWidget(
      MultiTranslationProvider(
        providers: appTranslationProviders,
        child: MaterialApp(
          theme: ThemeData(extensions: [AppThemes.light]),
          home: const ShellPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final report = ColdStartProfiler.instance.report;
    final interactiveElapsed = report.elapsedFor(ColdStartMilestone.firstScreenInteractive);

    expect(interactiveElapsed, isNotNull);
    expect(interactiveElapsed!.inMicroseconds, greaterThanOrEqualTo(0));
    expect(report.totalToTti.inMicroseconds, greaterThanOrEqualTo(0));

    final coldStartLogs = getIt<Talker>().history.whereType<ColdStartLog>();
    expect(coldStartLogs, isNotEmpty);
    expect(coldStartLogs.first.title, equals('ColdStartProfiler'));
    expect(coldStartLogs.first.key, equals('cold_start_profiler'));
    expect(coldStartLogs.first.message, contains('COLD START PERFORMANCE TELEMETRY REPORT'));
  });

  testWidgets('ShellPage mounts only SettingsPage on launch, deferring other tabs', (
    tester,
  ) async {
    await ThemeManager.instance.init();
    await getIt<AppInitializer>().init();

    await tester.pumpWidget(
      MultiTranslationProvider(
        providers: appTranslationProviders,
        child: MaterialApp(
          theme: ThemeData(extensions: [AppThemes.light]),
          home: const ShellPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Default tab is index 2 (SettingsPage)
    expect(find.byType(SettingsPage), findsOneWidget);
    // Tab 0 and Tab 1 must NOT be in the widget tree on launch
    expect(find.byType(HomeDashboardPage), findsNothing);
    expect(find.byType(ScannerPage), findsNothing);

    // Switch to Tab 0 (Home)
    getIt<ShellBloc>().onAction(const ShellAction.tabChanged(0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpAndSettle();

    // Now Home is mounted, while Settings remains preserved in tree
    expect(find.byType(HomeDashboardPage), findsOneWidget);
    expect(find.byType(SettingsPage, skipOffstage: false), findsOneWidget);
    // Scanner was never visited, so it remains unmounted
    expect(find.byType(ScannerPage, skipOffstage: false), findsNothing);
  });
}
