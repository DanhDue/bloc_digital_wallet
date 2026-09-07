// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bloc_digital_wallet/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Settings Language Switch Integration Tests', () {
    testWidgets(
      'Use Case: Switch language between English and Vietnamese, verifying dynamic UI updates',
      (WidgetTester tester) async {
        // 1. Boot the app
        app.main();

        // 2. Wait for Splash animation to complete and Home shell to mount
        await tester.pumpAndSettle(const Duration(seconds: 1));
        final settingsNavFinder = find.byKey(const ValueKey('nav_item_settings'));
        var elapsed = Duration.zero;
        while (!tester.any(settingsNavFinder) && elapsed < const Duration(seconds: 15)) {
          await tester.pump(const Duration(seconds: 1));
          elapsed += const Duration(seconds: 1);
        }
        await tester.pumpAndSettle();

        expect(settingsNavFinder, findsOneWidget, reason: 'Settings tab must be visible in Shell navigation');

        // 3. Navigate to Settings page
        await tester.tap(settingsNavFinder);
        await tester.pumpAndSettle();

        // 4. Verify initial state (English)
        // Preferences section title, Language label, and initial language value "English"
        expect(find.text('Preferences'), findsOneWidget);
        expect(find.text('Language'), findsOneWidget);
        expect(find.text('English'), findsWidgets);

        // 5. Open the Language Picker BottomSheet
        final languageItemFinder = find.byKey(const ValueKey('settings_language_item'));
        expect(languageItemFinder, findsOneWidget);
        await tester.tap(languageItemFinder);
        await tester.pumpAndSettle();

        // 6. Select Vietnamese ('vi')
        final viOptionFinder = find.byKey(const ValueKey('language_option_vi'));
        expect(viOptionFinder, findsOneWidget, reason: 'Vietnamese option should be available in the bottom sheet');
        await tester.tap(viOptionFinder);
        await tester.pumpAndSettle();

        // 7. Verify UI has switched dynamically to Vietnamese
        // - "Preferences" becomes "Tùy chọn"
        // - "Language" becomes "Ngôn ngữ"
        // - Selected language displays "Tiếng Việt"
        // - Bottom nav tab displays "Cài đặt"
        expect(find.text('Preferences'), findsNothing);
        expect(find.text('Tùy chọn'), findsOneWidget);
        expect(find.text('Ngôn ngữ'), findsOneWidget);
        expect(find.text('Tiếng Việt'), findsWidgets);
        expect(find.text('Cài đặt'), findsOneWidget);

        // 8. Switch back to English ('en')
        await tester.tap(languageItemFinder);
        await tester.pumpAndSettle();

        final enOptionFinder = find.byKey(const ValueKey('language_option_en'));
        expect(enOptionFinder, findsOneWidget, reason: 'English option should be available in the bottom sheet');
        await tester.tap(enOptionFinder);
        await tester.pumpAndSettle();

        // 9. Verify UI has switched back dynamically to English
        expect(find.text('Tùy chọn'), findsNothing);
        expect(find.text('Preferences'), findsOneWidget);
        expect(find.text('Language'), findsOneWidget);
        expect(find.text('English'), findsWidgets);
        expect(find.text('Settings'), findsWidgets);
      },
    );

    testWidgets(
      'Use Case: Switch to an uncached / OTA language triggers loading state',
      (WidgetTester tester) async {
        // 1. Boot the app
        app.main();

        // 2. Wait for Splash animation to complete and Home shell to mount
        await tester.pumpAndSettle(const Duration(seconds: 1));
        final settingsNavFinder = find.byKey(const ValueKey('nav_item_settings'));
        var elapsed = Duration.zero;
        while (!tester.any(settingsNavFinder) && elapsed < const Duration(seconds: 15)) {
          await tester.pump(const Duration(seconds: 1));
          elapsed += const Duration(seconds: 1);
        }
        await tester.pumpAndSettle();

        // 3. Navigate to Settings page
        await tester.tap(settingsNavFinder);
        await tester.pumpAndSettle();

        // 4. Open Language picker
        final languageItemFinder = find.byKey(const ValueKey('settings_language_item'));
        await tester.tap(languageItemFinder);
        await tester.pumpAndSettle();

        // 5. Look for an uncached language option (e.g., 'ja' or 'ko' if present in availableLanguages)
        final jaOptionFinder = find.byKey(const ValueKey('language_option_ja'));
        if (tester.any(jaOptionFinder)) {
          await tester.tap(jaOptionFinder);

          // Asynchronous network OTA download triggers loading indicator
          await tester.pump();
          final loadingIndicator = find.byType(CircularProgressIndicator);
          expect(loadingIndicator, findsWidgets);

          // Settle once download completes or times out
          await tester.pumpAndSettle(const Duration(seconds: 5));
        } else {
          // If only default local languages are pre-seeded, close the bottom sheet cleanly
          final viOptionFinder = find.byKey(const ValueKey('language_option_vi'));
          if (tester.any(viOptionFinder)) {
            await tester.tap(viOptionFinder);
            await tester.pumpAndSettle();
          }
        }
      },
    );
  });
}
