// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:d3_nexus_shield/main.dart' as app;

/// Reusable helper routines for Language Integration Tests.
abstract final class LanguageTestHelper {
  /// Launches the app from clean state and navigates to the Settings page.
  static Future<void> startAppAndOpenSettings(
    WidgetTester tester, {
    String initialLocale = 'en',
  }) async {
    await GetIt.instance.reset();
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    if (initialLocale.isNotEmpty) {
      await LocalizationManager.instance.setLocaleFromCode(initialLocale);
      await tester.pumpAndSettle(const Duration(seconds: 1));
    }

    await humanDelay(800);

    // Navigate to Settings Tab
    final settingsNavTab = find.byKey(const ValueKey('settings_nav_tab'));
    expect(
      settingsNavTab,
      findsOneWidget,
      reason: 'Settings tab icon must exist in bottom nav bar',
    );
    await tester.tap(settingsNavTab);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await humanDelay(800);

    // Verify that we are on Settings page
    final languageSettingItem = find.byKey(const ValueKey('settings_language_item'));
    expect(
      languageSettingItem,
      findsOneWidget,
      reason: 'Language item must exist in Settings page',
    );
  }

  /// Opens the language picker bottom sheet from the Settings page.
  static Future<void> openLanguagePicker(WidgetTester tester) async {
    final languageSettingItem = find.byKey(const ValueKey('settings_language_item'));
    expect(languageSettingItem, findsOneWidget);
    await tester.tap(languageSettingItem);
    await tester.pumpAndSettle();
    await humanDelay(1000);
  }

  /// Selects a language option in the bottom sheet by its base code (e.g. 'en', 'ja', 'vi', 'ko').
  static Future<void> selectLanguageOption(WidgetTester tester, String langBase) async {
    final option = find.byKey(ValueKey('language_option_$langBase'));
    expect(option, findsOneWidget, reason: 'Option for language $langBase should exist');
    await tester.tap(option);
    await tester.pump();
  }

  /// Waits for CustomLoadingWidget (Lottie animation) to disappear during remote OTA downloads.
  static Future<void> waitForLoadingToDisappear(
    WidgetTester tester, {
    int maxAttempts = 30,
    Duration pollInterval = const Duration(milliseconds: 400),
  }) async {
    int attempts = 0;
    while (find.byType(CustomLoadingWidget).evaluate().isNotEmpty && attempts < maxAttempts) {
      await tester.pump(pollInterval);
      attempts++;
    }
    expect(
      find.byType(CustomLoadingWidget),
      findsNothing,
      reason: 'Loading dialog should be dismissed after sync finishes',
    );
    await tester.pumpAndSettle();
  }

  /// Helper to introduce a visual pause for observing interactions on real devices/simulators.
  static Future<void> humanDelay([int milliseconds = 1000]) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }
}
