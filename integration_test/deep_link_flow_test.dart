// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:core/core.dart';
import 'package:scanner/scanner.dart';
import 'package:settings/settings.dart';
import 'package:d3_nexus_shield/deeplink/deep_link_coordinator.dart';
import 'package:d3_nexus_shield/shell/home_dashboard_page.dart';
import 'package:d3_nexus_shield/shell/shell_page.dart';
import 'package:d3_nexus_shield/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('DeepLink Flow End-to-End Integration Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
      PackageInfo.setMockInitialValues(
        appName: 'D3NexusShield',
        packageName: 'com.danhdue.d3nexusshield',
        version: '1.0.0',
        buildNumber: '1',
        buildSignature: '',
      );

      // Mock native logger bridge flush channel
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        'dev.flutter.pigeon.logger_native_bridge.NativeLogHostApi.triggerFlush',
        (ByteData? message) async {
          return const StandardMessageCodec().encodeMessage(<Object?>[null]);
        },
      );

      // Mock AppLinks method channel
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        'com.llfbandit.app_links/messages',
        (ByteData? message) async {
          return const StandardMethodCodec().encodeSuccessEnvelope(null);
        },
      );

      // Mock AppLinks event channel
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        'com.llfbandit.app_links/events',
        (ByteData? message) async {
          return const StandardMethodCodec().encodeSuccessEnvelope(null);
        },
      );
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        'dev.flutter.pigeon.logger_native_bridge.NativeLogHostApi.triggerFlush',
        null,
      );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        'com.llfbandit.app_links/messages',
        null,
      );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        'com.llfbandit.app_links/events',
        null,
      );
    });

    testWidgets(
      'Deep links to Scanner, Settings, and Unknown fallback transition tabs seamlessly in Shell',
      (WidgetTester tester) async {
        // 1. Launch App from fresh state
        await GetIt.instance.reset();
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 5));

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
