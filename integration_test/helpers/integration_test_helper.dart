// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:core/core.dart';
import 'package:d3_nexus_shield/main.dart' as app;
import 'package:d3_nexus_shield/shell/shell_page.dart';

/// Reusable helper routines for Super App Integration Tests.
abstract final class IntegrationTestHelper {
  /// Sets up platform mocks (SharedPreferences, PackageInfo, Pigeon logger bridge, AppLinks).
  static void setupPlatformMocks() {
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
  }

  /// Cleans up platform mocks.
  static void teardownPlatformMocks() {
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
  }

  /// Launches the app from clean state with offline mock responses for healthz and bootstrap.
  static Future<void> launchApp(WidgetTester tester) async {
    setupPlatformMocks();
    await GetIt.instance.reset();

    app.main(
      onDependenciesConfigured: () {
        // Reset LocalizationManager to English before runApp fires.
        //
        // LocalizationManager is a static singleton — it persists across tests.
        // If a prior test (e.g. UC2 en→ja) left it in 'ja' state, the app would
        // boot with stale 'ja' locale and a mid-test setLocaleFromCode('en') call
        // would trigger applyDynamicTranslations, causing SettingsPage's BlocListener
        // to showLoadingDialog which makes pumpUntil time out.
        //
        // D3NexusLogger IS available here (DI is configured), so the call succeeds.
        // We fire-and-forget — only the synchronous _currentLocale assignment matters;
        // the async OTA part is irrelevant for test setup.
        LocalizationManager.instance.setLocaleFromCode('en').ignore();

        final dio = GetIt.instance<Dio>();
        dio.interceptors.insert(
          0,
          InterceptorsWrapper(
            onRequest: (options, handler) {
              final uri = options.uri.toString();
              // Bootstrap is always mocked in integration tests — regardless of live vs offline.
              // Reason: the real bootstrap on Heroku frequently returns stale_translations (e.g.
              // en_US), which triggers a background OTA download that takes 30–50 s on cold
              // start.  This blocks Settings from rendering and makes pumpUntil time out.
              // User-initiated language switches (UC2 en→ja tap) still hit the live backend,
              // so OTA behaviour is tested on the critical path without startup interference.
              if (uri.contains('bootstrap')) {
                return handler.resolve(
                  Response(
                    requestOptions: options,
                    data: {
                      'success': true,
                      'message': 'Bootstrap successful',
                      'data': {
                        'stale_translations': [],
                        'stale_themes': [],
                        'removed_resources': [],
                        'active_campaign_theme_id': null,
                        'user_preferences': null,
                        'available_languages': [
                          {
                            'language_code': 'en_US',
                            'language_name': 'English (US)',
                            'version': '1.0.0',
                            'is_default': true,
                            'is_active': true,
                          },
                          {
                            'language_code': 'vi',
                            'language_name': 'Tiếng Việt',
                            'version': '1.0.0',
                            'is_default': false,
                            'is_active': true,
                          },
                          {
                            'language_code': 'ja_JP',
                            'language_name': '日本語',
                            'version': '1.0.0',
                            'is_default': false,
                            'is_active': true,
                          },
                          {
                            'language_code': 'ko_KR',
                            'language_name': '한국어',
                            'version': '1.0.5',
                            'is_default': false,
                            'is_active': true,
                          },
                        ],
                        'available_themes': [],
                      },
                    },
                    statusCode: 200,
                  ),
                );
              }

              final isLiveBackend = EnvironmentConfig.apiBaseUrl.contains('herokuapp.com');
              if (!isLiveBackend) {
                if (uri.contains('healthz')) {
                  return handler.resolve(
                    Response(
                      requestOptions: options,
                      data: {'success': true, 'data': 'healthy'},
                      statusCode: 200,
                    ),
                  );
                }
                if (uri.contains('translations')) {
                  return handler.resolve(
                    Response(
                      requestOptions: options,
                      data: {
                        'success': true,
                        'data': {
                          'version': '1.0.1',
                          'translations': {
                            'settings': {
                              'title': '設定',
                              'preferences': {'language': '言語'},
                            },
                          },
                        },
                      },
                      statusCode: 200,
                    ),
                  );
                }
              }
              if (uri.contains('transactions')) {
                return handler.resolve(
                  Response(
                    requestOptions: options,
                    data: {'success': true, 'data': []},
                    statusCode: 200,
                  ),
                );
              }
              if (uri.contains('tokens/accounts')) {
                return handler.resolve(
                  Response(
                    requestOptions: options,
                    data: {'success': true, 'data': []},
                    statusCode: 200,
                  ),
                );
              }
              if (uri.contains('markets')) {
                return handler.resolve(
                  Response(
                    requestOptions: options,
                    data: {'data': [], 'status': null},
                    statusCode: 200,
                  ),
                );
              }
              return handler.next(options);
            },
          ),
        );
      },
    );

    // Wait for Splash screen (8s min duration) and animation to finish navigating into ShellPage
    await pumpUntil(
      tester,
      find.byType(ShellPage),
      timeout: const Duration(seconds: 15),
      reason: 'ShellPage must be mounted after Splash screen completes',
    );
    await tester.pumpAndSettle();
  }

  /// Switches tab via bottom navigation bar, allowing double-tap gesture delay to elapse.
  static Future<void> switchTab(WidgetTester tester, Key tabKey) async {
    final tabFinder = find.byKey(tabKey);
    expect(tabFinder, findsOneWidget, reason: 'Tab key $tabKey must exist');
    await tester.tap(tabFinder);
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
  }

  /// Repeatedly pumps frames until [finder] matches at least one widget or [timeout] expires.
  /// Solves the issue where an async API call or state update is in-flight while pumpAndSettle
  /// would otherwise return prematurely or hang on infinite animations.
  static Future<void> pumpUntil(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
    Duration pollInterval = const Duration(milliseconds: 100),
    String? reason,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (stopwatch.elapsed < timeout) {
      await tester.pump(pollInterval);
      if (finder.evaluate().isNotEmpty) {
        return;
      }
    }
    throw TestFailure(reason ?? 'Timed out ($timeout) waiting for widget matching $finder');
  }

  /// Repeatedly pumps frames until [finder] matches 0 widgets or [timeout] expires.
  /// Useful for waiting for loading dialogs, spinners, or bottom sheets to dismiss.
  static Future<void> pumpUntilDisappeared(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
    Duration pollInterval = const Duration(milliseconds: 100),
    String? reason,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (stopwatch.elapsed < timeout) {
      await tester.pump(pollInterval);
      if (finder.evaluate().isEmpty) {
        return;
      }
    }
    throw TestFailure(
      reason ?? 'Timed out ($timeout) waiting for widget matching $finder to disappear',
    );
  }

  /// Repeatedly pumps frames until [condition] returns true or [timeout] expires.
  /// Ideal for waiting on business state, locale change, or network synchronization.
  static Future<void> waitUntil(
    WidgetTester tester,
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 10),
    Duration pollInterval = const Duration(milliseconds: 100),
    String? reason,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (stopwatch.elapsed < timeout) {
      if (condition()) {
        return;
      }
      await tester.pump(pollInterval);
    }
    throw TestFailure(reason ?? 'Timed out ($timeout) waiting for condition to become true');
  }
}
