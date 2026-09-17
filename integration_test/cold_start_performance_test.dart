// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:d3_nexus_shield/main.dart' as app;
import 'package:d3_nexus_shield/shell/widgets/custom_bottom_nav_bar.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(
          'dev.flutter.pigeon.logger_native_bridge.NativeLogHostApi.triggerFlush',
          (ByteData? message) async {
            return const StandardMessageCodec().encodeMessage(<Object?>[null]);
          },
        );

    // Mock AppLinks method channel
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('com.llfbandit.app_links/messages', (
          ByteData? message,
        ) async {
          return const StandardMethodCodec().encodeSuccessEnvelope(null);
        });

    // Mock AppLinks event channel
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('com.llfbandit.app_links/events', (
          ByteData? message,
        ) async {
          return const StandardMethodCodec().encodeSuccessEnvelope(null);
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(
          'dev.flutter.pigeon.logger_native_bridge.NativeLogHostApi.triggerFlush',
          null,
        );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('com.llfbandit.app_links/messages', null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('com.llfbandit.app_links/events', null);
  });

  group('Cold Start Optimization — Acceptance Tests', () {
    testWidgets('CustomBottomNavBar renders on first settled frame', (
      tester,
    ) async {
      await GetIt.instance.reset();
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(CustomBottomNavBar), findsOneWidget);
    });

    testWidgets(
      'lazy tab navigation — Settings → Home → Scanner without crash',
      (tester) async {
        await GetIt.instance.reset();
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Navigate to Home tab
        final homeIcon = find.byIcon(Icons.home_outlined);
        if (homeIcon.evaluate().isNotEmpty) {
          await tester.tap(homeIcon);
          await tester.pumpAndSettle();
        }

        // Navigate to Scanner tab
        final scannerIcon = find.byIcon(Icons.qr_code_scanner);
        if (scannerIcon.evaluate().isNotEmpty) {
          await tester.tap(scannerIcon);
          await tester.pumpAndSettle();
        }

        // Return to Settings
        final settingsTab = find.byKey(const ValueKey('settings_nav_tab'));
        await tester.tap(settingsTab);
        await tester.pumpAndSettle();

        expect(settingsTab, findsOneWidget);
      },
    );

    testWidgets('RepaintBoundary layers present on CustomBottomNavBar', (
      tester,
    ) async {
      await GetIt.instance.reset();
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final boundaries = find.descendant(
        of: find.byType(CustomBottomNavBar),
        matching: find.byType(RepaintBoundary),
      );
      expect(boundaries, findsAtLeast(1));
    });
  });
}
