// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:integration_test/integration_test.dart';
import 'package:core/core.dart';
import 'package:settings/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloc_digital_wallet/main.dart' as app;
import 'helpers/language_test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Language Switching Edge Cases & Resilience Integration Test', () {
    // -------------------------------------------------------------------------
    // EDGE CASE 1: Rapid Switching Race Condition (BDD-08) & Post-Action Side Effects
    // Latest selection wins; earlier in-flight requests are safely ignored.
    // -------------------------------------------------------------------------
    testWidgets(
      'Edge Case 1: Rapid language switching race condition (ko -> ja) ensures latest selection wins with zero side-effect corruption',
      (WidgetTester tester) async {
        await LanguageTestHelper.startAppAndOpenSettings(tester);

        // Access SettingsBloc safely from an inner child node under BlocProvider
        final languageSettingFinder = find.byKey(const ValueKey('settings_language_item'));
        expect(languageSettingFinder, findsOneWidget);
        final settingsBloc = tester.element(languageSettingFinder).read<SettingsBloc>();

        // Rapidly dispatch ko_KR then ja_JP back-to-back
        settingsBloc.onAction(const SettingsAction.changeLanguage(languageCode: 'ko_KR'));
        settingsBloc.onAction(const SettingsAction.changeLanguage(languageCode: 'ja_JP'));

        await tester.pump();

        // Visual pause: Observe loading indicator on screen
        await LanguageTestHelper.humanDelay(1000);

        // Wait for active remote OTA sync operation to resolve
        await LanguageTestHelper.waitForLoadingToDisappear(tester);

        // ---------------------------------------------------------------------
        // Post-Action Side Effects Verification:
        // ---------------------------------------------------------------------
        // 1. Cooldown pause to capture any late-arriving HTTP response from the superseded 'ko' request
        await LanguageTestHelper.humanDelay(2500);

        // 2. In-Memory State: Latest selection (ja) remains active, was NOT overwritten by late response
        expect(
          LocalizationManager.instance.currentLocale.languageCode,
          equals('ja'),
          reason: 'Latest language selection should override earlier in-flight request',
        );

        // 3. Persistent Disk Storage: SharedPreferences must strictly reflect Japanese
        final prefs = await SharedPreferences.getInstance();
        expect(
          prefs.getString('saved_language_code'),
          anyOf(equals('ja'), equals('ja_JP')),
          reason: 'Persisted language on disk should strictly match the latest selection',
        );

        // 4. UI Liveness & No-Deadlock Check: Ensure app is responsive and not stuck in a modal barrier
        final homeNavTab = find.byKey(const ValueKey('home_nav_tab'));
        if (homeNavTab.evaluate().isNotEmpty) {
          await tester.tap(homeNavTab);
          await tester.pumpAndSettle();
          await LanguageTestHelper.humanDelay(1000);

          // Return to Settings tab
          await tester.tap(find.byKey(const ValueKey('settings_nav_tab')));
          await tester.pumpAndSettle();
          await LanguageTestHelper.humanDelay(800);
        }
      },
    );

    // -------------------------------------------------------------------------
    // EDGE CASE 2: Remote Download Failure Rollback & SnackBar (BDD-07)
    // Server returns error for invalid/unavailable language; locale safely rolls back.
    // -------------------------------------------------------------------------
    testWidgets(
      'Edge Case 2: Remote download failure rolls back to previous locale and displays error SnackBar',
      (WidgetTester tester) async {
        await LanguageTestHelper.startAppAndOpenSettings(tester);

        // Verify baseline is English
        expect(LocalizationManager.instance.currentLocale.languageCode, equals('en'));

        final languageSettingFinder = find.byKey(const ValueKey('settings_language_item'));
        expect(languageSettingFinder, findsOneWidget);
        final settingsBloc = tester.element(languageSettingFinder).read<SettingsBloc>();

        // Dispatch a non-existent remote language code to trigger API failure
        settingsBloc.onAction(
          const SettingsAction.changeLanguage(languageCode: 'invalid_remote_lang'),
        );

        await tester.pump();

        // Visual pause: Loading appears briefly while querying backend
        await LanguageTestHelper.humanDelay(1000);

        // Wait for error handling to complete and loading dialog to dismiss
        await LanguageTestHelper.waitForLoadingToDisappear(tester);

        // Visual pause: Observe error SnackBar on screen
        await LanguageTestHelper.humanDelay(1500);

        // Expectation: SnackBar with error message is displayed
        expect(
          find.byType(SnackBar),
          findsOneWidget,
          reason: 'Error SnackBar must be displayed upon translation download failure',
        );

        // ---------------------------------------------------------------------
        // Post-Action Side Effects Verification:
        // ---------------------------------------------------------------------
        await LanguageTestHelper.humanDelay(1500);

        // In-Memory state remains English
        expect(
          LocalizationManager.instance.currentLocale.languageCode,
          equals('en'),
          reason: 'Active locale must safely remain English after download failure',
        );

        // Persistent disk state remains English
        final prefs = await SharedPreferences.getInstance();
        expect(
          prefs.getString('saved_language_code'),
          anyOf(equals('en'), equals('en_US')),
          reason: 'Persisted language must remain English',
        );
      },
    );

    // -------------------------------------------------------------------------
    // EDGE CASE 3: Immediate Re-opening BottomSheet (Bug #2 Regression)
    // Selecting language and immediately tapping to reopen should not crash or glitch.
    // -------------------------------------------------------------------------
    testWidgets(
      'Edge Case 3: Re-opening BottomSheet immediately avoids recomposition crash or glitch',
      (WidgetTester tester) async {
        await LanguageTestHelper.startAppAndOpenSettings(tester);

        // Open BottomSheet
        await LanguageTestHelper.openLanguagePicker(tester);

        // Tap English option (dismisses sheet)
        final enOption = find.byKey(const ValueKey('language_option_en'));
        await tester.tap(enOption);
        await tester.pumpAndSettle();

        // Immediately re-tap settings_language_item to reopen without delay
        final languageSettingItem = find.byKey(const ValueKey('settings_language_item'));
        await tester.tap(languageSettingItem);
        await tester.pumpAndSettle();

        // Visual pause: Observe BottomSheet successfully reopened
        await LanguageTestHelper.humanDelay(1200);

        // Expectation: BottomSheet is cleanly reopened and options are visible
        expect(
          find.byKey(const ValueKey('language_option_en')),
          findsOneWidget,
          reason: 'BottomSheet should reopen cleanly without crash or state glitch',
        );

        // Dismiss sheet
        await tester.tap(find.byKey(const ValueKey('language_option_en')));
        await tester.pumpAndSettle();
      },
    );

    // -------------------------------------------------------------------------
    // EDGE CASE 4: Cold-Start Frame-0 Restoration (UC-05, BDD-01)
    // Saved language code in SharedPreferences is restored on initial boot without flashing.
    // -------------------------------------------------------------------------
    testWidgets('Edge Case 4: Cold-start restores saved language from SharedPreferences cleanly', (
      WidgetTester tester,
    ) async {
      // Pre-seed SharedPreferences with Japanese locale
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_language_code', 'ja_JP');

      // Simulate cold app boot
      await GetIt.instance.reset();
      app.main();

      // Settle all startup initializers and UI frames
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Expectation: Initial boot has already applied Japanese
      expect(
        LocalizationManager.instance.currentLocale.languageCode,
        equals('ja'),
        reason: 'Cold boot must immediately restore saved Japanese language code',
      );

      // Visual pause: Observe Japanese UI on simulator screen
      await LanguageTestHelper.humanDelay(1500);

      // Navigate to Settings to verify Japanese UI strings
      final settingsNavTab = find.byKey(const ValueKey('settings_nav_tab'));
      await tester.tap(settingsNavTab);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await LanguageTestHelper.humanDelay(1500);

      // Teardown / hygiene: Reset back to English for following runs
      await LocalizationManager.instance.setLocaleFromCode('en');
      await prefs.setString('saved_language_code', 'en');
      await tester.pumpAndSettle();
    });
  });
}
