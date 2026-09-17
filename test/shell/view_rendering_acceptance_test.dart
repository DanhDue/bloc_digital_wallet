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
import 'package:d3_nexus_shield/shell/widgets/custom_bottom_nav_bar.dart';
import 'package:d3_nexus_shield/theme/app_theme_data.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    if (!getIt.isRegistered<AppRouter>()) {
      await configureDependencies();
    }
  });

  group('View Rendering Acceptance Tests', () {
    testWidgets('Scenario 4.1: HomeDashboardPage has zero nested Scaffolds', (
      tester,
    ) async {
      await ThemeManager.instance.init();
      await getIt<AppInitializer>().init();

      await tester.pumpWidget(
        MultiTranslationProvider(
          providers: appTranslationProviders,
          child: MaterialApp(
            theme: AppThemeData.lightTheme,
            darkTheme: AppThemeData.darkTheme,
            home: const ShellPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Switch to Home tab (index 0)
      await tester.tap(find.byKey(const ValueKey('home_nav_tab')));
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      // HomeDashboardPage is mounted and visible
      expect(find.byType(HomeDashboardPage), findsOneWidget);
      expect(find.text('Super App'), findsOneWidget);
      expect(find.text('Super App Template'), findsOneWidget);
      expect(
        find.text('Modular Clean Architecture + MVI for Flutter'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.dashboard_customize_outlined), findsOneWidget);

      // Verify that HomeDashboardPage itself has zero Scaffolds in its subtree
      final innerScaffolds = find.descendant(
        of: find.byType(HomeDashboardPage),
        matching: find.byType(Scaffold),
      );
      expect(innerScaffolds, findsNothing);
    });

    testWidgets('Scenario 4.2: Two-stage shadow transition inside ShellPage', (
      tester,
    ) async {
      await ThemeManager.instance.init();
      await getIt<AppInitializer>().init();

      await tester.pumpWidget(
        MultiTranslationProvider(
          providers: appTranslationProviders,
          child: MaterialApp(
            theme: AppThemeData.lightTheme,
            darkTheme: AppThemeData.darkTheme,
            home: const ShellPage(),
          ),
        ),
      );

      // Frame 0: Immediately after mount before post-frame callback fires
      final outerContainerFinder = find.descendant(
        of: find.byType(CustomBottomNavBar),
        matching: find.byType(Container),
      ).first;

      final Container frame0Container = tester.widget<Container>(outerContainerFinder);
      final frame0Decoration = frame0Container.decoration as BoxDecoration;
      expect(frame0Decoration.boxShadow, isNull);

      // Frame 1: Flush post-frame callbacks
      await tester.pumpAndSettle();

      final Container frame1Container = tester.widget<Container>(outerContainerFinder);
      final frame1Decoration = frame1Container.decoration as BoxDecoration;
      expect(frame1Decoration.boxShadow, isNotNull);
      expect(frame1Decoration.boxShadow!.first.blurRadius, equals(10));
    });

    test('Scenario 4.3: AppThemeData static cache integrity', () {
      expect(AppThemeData.lightTheme.scaffoldBackgroundColor, isNotNull);
      expect(AppThemeData.darkTheme.scaffoldBackgroundColor, isNotNull);
      expect(AppThemeData.lightTheme.extension<AppThemes>(), equals(AppThemes.light));
      expect(AppThemeData.darkTheme.extension<AppThemes>(), equals(AppThemes.dark));
    });
  });
}
