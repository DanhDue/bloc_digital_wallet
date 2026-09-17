// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';
import 'integration_test_helper.dart';

/// Reusable helper routines for Language Integration Tests.
abstract final class LanguageTestHelper {
  /// Launches the app from clean state and navigates to the Settings page.
  static Future<void> startAppAndOpenSettings(
    WidgetTester tester, {
    String initialLocale = 'en',
  }) async {
    await IntegrationTestHelper.launchApp(tester);

    if (initialLocale.isNotEmpty) {
      final targetLang = initialLocale.split('_').first;
      await LocalizationManager.instance.setLocaleFromCode(initialLocale);
      // Wait until LocalizationManager confirms the locale is applied.
      // NOTE: pumpAndSettle(Duration(seconds:3)) was WRONG — that arg is the frame
      // interval, not a timeout. Use waitUntil to poll the actual state instead.
      await IntegrationTestHelper.waitUntil(
        tester,
        () => LocalizationManager.instance.currentLocale.languageCode == targetLang,
        timeout: const Duration(seconds: 10),
        reason: 'LocalizationManager should apply locale $targetLang',
      );
      await tester.pump(const Duration(milliseconds: 300));
    }

    await humanDelay(800);

    // Navigate to Settings Tab
    await IntegrationTestHelper.switchTab(tester, const ValueKey('settings_nav_tab'));

    // Wait until Settings page shows the language item.
    //
    // 30s budget handles the worst case where:
    //   1. Bootstrap response marks en_US translations as stale, triggering a full
    //      OTA download (~10-15s on Heroku) that shows CustomLoadingWidget.
    //   2. SettingsBloc has not yet emitted its first state after the tab switch.
    //
    // pumpUntil polls at 100ms — it will find the widget naturally once the
    // download completes and CustomLoadingWidget dismisses, without requiring a
    // separate pumpUntilDisappeared guard that races against late-appearing widgets.
    final languageSettingItem = find.byKey(const ValueKey('settings_language_item'));
    await IntegrationTestHelper.pumpUntil(
      tester,
      languageSettingItem,
      timeout: const Duration(seconds: 30),
      reason: 'Language item must exist in Settings page',
    );
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
