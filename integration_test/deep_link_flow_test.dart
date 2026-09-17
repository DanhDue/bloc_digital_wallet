// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:d3_nexus_shield/deeplink/deep_link_coordinator.dart';
import 'package:d3_nexus_shield/shell/home_dashboard_page.dart';
import 'package:d3_nexus_shield/shell/shell_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:scanner/scanner.dart';
import 'package:settings/settings.dart';

import 'helpers/integration_test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('DeepLink Flow End-to-End Integration Tests', () {
    setUp(() {
      IntegrationTestHelper.setupPlatformMocks();
    });

    tearDown(() {
      IntegrationTestHelper.teardownPlatformMocks();
    });

    testWidgets(
      'Deep links to Scanner, Settings, and Unknown fallback transition tabs seamlessly in Shell',
      (WidgetTester tester) async {
        // 1. Launch App from fresh state
        await IntegrationTestHelper.launchApp(tester);

        expect(find.byType(ShellPage), findsOneWidget, reason: 'ShellPage must be mounted');

        final coordinator = GetIt.instance<DeepLinkCoordinator>();
        expect(coordinator, isNotNull);

        // 2. Dispatch Custom URL Scheme to Scanner: d3nexus://scanner
        coordinator.handleUri(Uri.parse('d3nexus://scanner'));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        expect(
          find.byType(ScannerPage),
          findsOneWidget,
          reason: 'ScannerPage must be displayed when navigating via d3nexus://scanner',
        );

        // 3. Dispatch Universal AppLink to Settings: https://app.d3nexus.com/settings
        coordinator.handleUri(Uri.parse('https://app.d3nexus.com/settings'));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        expect(
          find.byType(SettingsPage),
          findsOneWidget,
          reason: 'SettingsPage must be displayed when navigating via Universal Link',
        );

        // 4. Dispatch Unknown Fallback DeepLink: d3nexus://unknown_route
        coordinator.handleUri(Uri.parse('d3nexus://unknown_route'));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        expect(
          find.byType(HomeDashboardPage),
          findsOneWidget,
          reason: 'Unknown link must fallback safely to Home tab without crashing',
        );
      },
    );
  });
}
