// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:authentication/authentication.dart';
import 'package:core/core.dart';
import 'package:scanner/scanner.dart';
import 'package:settings/settings.dart';
import 'package:transaction/transaction.dart';
import 'package:trends/trends.dart';
import 'package:wallet/wallet.dart';
import 'package:d3_nexus_shield/app_router.dart';
import 'package:d3_nexus_shield/shell/shell_page.dart';

import 'helpers/integration_test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Super App Multi-Feature End-to-End UI Integration Tests', () {
    setUp(() {
      IntegrationTestHelper.setupPlatformMocks();
    });

    tearDown(() {
      IntegrationTestHelper.teardownPlatformMocks();
    });

    testWidgets(
      'Complete User Journey: Boot -> Shell -> Wallet -> Transaction -> Scanner -> Trends -> Settings -> Auth Login',
      (WidgetTester tester) async {
        // ---------------------------------------------------------------------
        // 1. Boot Application & Onboard Flow
        // ---------------------------------------------------------------------
        await IntegrationTestHelper.launchApp(tester);

        // Verify ShellPage is mounted and WalletPage is the initial active tab (Tab 0)
        expect(
          find.byType(ShellPage),
          findsOneWidget,
          reason: 'ShellPage must be mounted after boot',
        );
        expect(
          find.byType(WalletPage),
          findsOneWidget,
          reason: 'WalletPage must be active on Tab 0',
        );

        // ---------------------------------------------------------------------
        // 2. Wallet Mini-App Features (Tab 0)
        // ---------------------------------------------------------------------
        // Verify Quick Action buttons are rendered
        expect(
          find.text('Buy'),
          findsOneWidget,
          reason: 'Buy quick action button should be visible',
        );
        expect(
          find.text('Send'),
          findsOneWidget,
          reason: 'Send quick action button should be visible',
        );
        expect(
          find.text('Receive'),
          findsOneWidget,
          reason: 'Receive quick action button should be visible',
        );

        // Verify Nested Tabs in Wallet (Tokens and Collectibles / NFTs)
        final tokensTabFinder = find.text('Tokens');
        final nftsTabFinder = find.text('NFTs');
        expect(tokensTabFinder, findsOneWidget, reason: 'Tokens tab header should be visible');
        expect(nftsTabFinder, findsOneWidget, reason: 'NFTs tab header should be visible');

        // Switch to NFTs tab inside WalletPage
        await tester.tap(nftsTabFinder);
        await tester.pumpAndSettle();
        expect(
          find.byType(NftsListPage),
          findsOneWidget,
          reason: 'NftsListPage should be active after tapping NFTs tab',
        );

        // Switch back to Tokens tab
        await tester.tap(tokensTabFinder);
        await tester.pumpAndSettle();
        expect(
          find.byType(TokenListPage),
          findsOneWidget,
          reason: 'TokenListPage should be active after tapping Tokens tab',
        );

        // ---------------------------------------------------------------------
        // 3. Transaction Mini-App Feature (Tab 1)
        // ---------------------------------------------------------------------
        await IntegrationTestHelper.switchTab(tester, const ValueKey('transaction_nav_tab'));

        expect(
          find.byType(TransactionPage),
          findsOneWidget,
          reason: 'TransactionPage must be displayed on Tab 1',
        );

        // ---------------------------------------------------------------------
        // 4. Scanner Mini-App Feature (Tab 2 - Center Elevated Button)
        // ---------------------------------------------------------------------
        await IntegrationTestHelper.switchTab(tester, const ValueKey('scanner_nav_tab'));

        expect(
          find.byType(ScannerPage),
          findsOneWidget,
          reason: 'ScannerPage must be displayed when tapping Scanner tab',
        );

        // ---------------------------------------------------------------------
        // 5. Trends Mini-App Feature (Tab 3)
        // ---------------------------------------------------------------------
        await IntegrationTestHelper.switchTab(tester, const ValueKey('trends_nav_tab'));

        expect(
          find.byType(TrendsPage),
          findsOneWidget,
          reason: 'TrendsPage must be displayed on Tab 3',
        );

        // ---------------------------------------------------------------------
        // 6. Settings Mini-App Feature (Tab 4)
        // ---------------------------------------------------------------------
        await IntegrationTestHelper.switchTab(tester, const ValueKey('settings_nav_tab'));

        expect(
          find.byType(SettingsPage),
          findsOneWidget,
          reason: 'SettingsPage must be displayed on Tab 4',
        );

        // ---------------------------------------------------------------------
        // 7. Authentication Feature (LoginPage Navigation & Form Verification)
        // ---------------------------------------------------------------------
        final appRouter = GetIt.instance<AppRouter>();
        appRouter.push(const LoginRoute());
        await tester.pumpAndSettle();

        expect(
          find.byType(LoginPage),
          findsOneWidget,
          reason: 'LoginPage must be mounted when navigating to LoginRoute',
        );

        // Verify email and password form fields exist
        final textFields = find.byType(TextField);
        expect(
          textFields,
          findsAtLeastNWidgets(2),
          reason: 'Email and password input fields must exist on LoginPage',
        );

        // Enter email and password
        await tester.enterText(textFields.first, 'tester@danhdue.com');
        await tester.enterText(textFields.at(1), 'SecurePassword123!');
        await tester.pumpAndSettle();

        expect(
          find.text('tester@danhdue.com'),
          findsOneWidget,
          reason: 'Email text should be entered successfully',
        );
      },
    );
  });
}
