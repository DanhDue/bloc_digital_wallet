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
    ColdStartProfiler.instance.reset();
  });

  tearDown(() {
    ColdStartProfiler.instance.reset();
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
  });
}
