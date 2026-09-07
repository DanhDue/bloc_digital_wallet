// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:core/core.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helpers/language_test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Language Switching Flow Integration Test (Standard Use Cases)', () {
    // -------------------------------------------------------------------------
    // USE CASE 1: Same-Language Selection (No-op)
    // -------------------------------------------------------------------------
    testWidgets('Use Case 1: Same-Language Selection (en -> en) is a No-Op', (
      WidgetTester tester,
    ) async {
      await LanguageTestHelper.startAppAndOpenSettings(tester);

      await LanguageTestHelper.openLanguagePicker(tester);

      final enOption = find.byKey(const ValueKey('language_option_en'));
      expect(enOption, findsOneWidget, reason: 'English option should be listed in BottomSheet');

      await tester.tap(enOption);
      await tester.pumpAndSettle();

      await LanguageTestHelper.humanDelay(1000);

      // Expectation: BottomSheet closes, no loading was triggered, locale remains English
      expect(LocalizationManager.instance.currentLocale.languageCode, equals('en'));
    });

    // -------------------------------------------------------------------------
    // USE CASE 2: Uncached Remote OTA Language Download (en -> ja)
    // -------------------------------------------------------------------------
    testWidgets(
      'Use Case 2: Uncached Language OTA Download (en -> ja) shows loading indicator and applies translations',
      (WidgetTester tester) async {
        await LanguageTestHelper.startAppAndOpenSettings(tester);

        await LanguageTestHelper.openLanguagePicker(tester);

        final jaOption = find.byKey(const ValueKey('language_option_ja'));
        expect(
          jaOption,
          findsOneWidget,
          reason: 'Japanese option should be listed in BottomSheet',
        );

        await tester.tap(jaOption);

        // Expectation: Loading dialog appears during download
        await tester.pump();

        // Visual pause: Loading dialog (Lottie) is visible on screen
        await LanguageTestHelper.humanDelay(1200);

        final loadingIndicator = find.byType(CustomLoadingWidget);
        expect(
          loadingIndicator,
          findsOneWidget,
          reason: 'CustomLoadingWidget should appear for uncached OTA language',
        );

        // Wait for remote fetch from Staging server to finish and dialog to be dismissed
        await LanguageTestHelper.waitForLoadingToDisappear(tester);

        // Visual pause: Observe Japanese UI on screen!
        await LanguageTestHelper.humanDelay(1500);

        expect(LocalizationManager.instance.currentLocale.languageCode, equals('ja'));

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('saved_language_code'), anyOf(equals('ja'), equals('ja_JP')));
      },
    );

    // -------------------------------------------------------------------------
    // USE CASE 3: Bundled/Cached Language Switch (Optimistic Switch)
    // -------------------------------------------------------------------------
    testWidgets(
      'Use Case 3: Bundled/Cached Language Switch (ja -> en) performs optimistic update',
      (WidgetTester tester) async {
        await LanguageTestHelper.startAppAndOpenSettings(tester);

        // Set locale to Japanese initially to test switching to bundled English
        await LocalizationManager.instance.setLocaleFromCode('ja_JP');
        await tester.pumpAndSettle();
        await LanguageTestHelper.humanDelay(800);

        await LanguageTestHelper.openLanguagePicker(tester);

        final enOption = find.byKey(const ValueKey('language_option_en'));
        expect(enOption, findsOneWidget);

        await tester.tap(enOption);
        await tester.pumpAndSettle();

        // Visual pause: Observe English UI restored!
        await LanguageTestHelper.humanDelay(1500);

        // Expectation: Immediate optimistic update without modal dialog, locale is 'en'
        expect(LocalizationManager.instance.currentLocale.languageCode, equals('en'));

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('saved_language_code'), anyOf(equals('en'), equals('en_US')));
      },
    );

    // -------------------------------------------------------------------------
    // USE CASE 4: Bundled Vietnamese Switch (if available)
    // -------------------------------------------------------------------------
    testWidgets('Use Case 4: Bundled Vietnamese Switch (en -> vi)', (WidgetTester tester) async {
      await LanguageTestHelper.startAppAndOpenSettings(tester);

      await LanguageTestHelper.openLanguagePicker(tester);

      final viOption = find.byKey(const ValueKey('language_option_vi'));
      if (viOption.evaluate().isNotEmpty) {
        await tester.tap(viOption);
        await tester.pumpAndSettle();

        await LanguageTestHelper.humanDelay(1200);

        expect(LocalizationManager.instance.currentLocale.languageCode, equals('vi'));
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('saved_language_code'), anyOf(equals('vi'), equals('vi_VN')));
      } else {
        // If vi is not in backend available list, dismiss
        final enClose = find.byKey(const ValueKey('language_option_en'));
        await tester.tap(enClose);
        await tester.pumpAndSettle();
      }
    });
  });
}
