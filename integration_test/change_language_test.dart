// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bloc_digital_wallet/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Settings Language Switch Integration Test', () {
    testWidgets('Switch to an uncached language shows loading', (WidgetTester tester) async {
      // 1. Start the app
      app.main();

      // Wait for app to finish booting (animations, splash screen, etc.)
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Note: If your app has a Login screen, you must add steps here to interact
      // with the login fields and navigate to the Home screen first!
      // Example:
      // await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
      // ...

      // 2. Navigate to Settings (Assuming there is a bottom nav bar with 'Settings' icon)
      final settingsTab = find.byIcon(Icons.settings); // Change this to match your actual UI
      if (settingsTab.evaluate().isNotEmpty) {
        await tester.tap(settingsTab);
        await tester.pumpAndSettle();
      }

      // 3. Find and tap the Language menu item
      final languageIcon = find.byIcon(Icons.language_outlined);
      expect(languageIcon, findsOneWidget);
      await tester.tap(languageIcon);

      // Wait for the BottomSheet to open
      await tester.pumpAndSettle();

      // 4. Select a new language (e.g. Japanese)
      final jaLanguage = find.byWidgetPredicate(
        (widget) => widget is Text && (widget.data == '日本語' || widget.data == 'Japanese'),
      );
      expect(jaLanguage, findsOneWidget);
      await tester.tap(jaLanguage);

      // 5. Verify the Loading indicator appears (Not Cached scenario)
      // Because it's an asynchronous network call, we pump once to trigger the state change
      await tester.pump();

      // Verify a loading spinner is in the widget tree (SmartDialog or CircularProgressIndicator)
      final loadingIndicator = find.byType(CircularProgressIndicator);
      expect(loadingIndicator, findsWidgets);

      // 6. Wait for the network call to finish and UI to settle
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 7. Verify the loading indicator is gone
      expect(loadingIndicator, findsNothing);
    });
  });
}
