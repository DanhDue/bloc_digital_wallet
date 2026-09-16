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
        final dio = GetIt.instance<Dio>();
        dio.interceptors.insert(
          0,
          InterceptorsWrapper(
            onRequest: (options, handler) {
              final uri = options.uri.toString();
              if (uri.contains('healthz')) {
                return handler.resolve(
                  Response(
                    requestOptions: options,
                    data: {'success': true, 'data': 'healthy'},
                    statusCode: 200,
                  ),
                );
              }
              if (uri.contains('bootstrap')) {
                return handler.resolve(
                  Response(
                    requestOptions: options,
                    data: {
                      'success': true,
                      'data': {
                        'translations': [],
                        'user_preferences': {'selected_language': 'en'},
                        'available_languages': [
                          {
                            'language_code': 'en',
                            'language_name': 'English',
                            'is_default': true,
                            'is_active': true,
                          },
                          {
                            'language_code': 'vi',
                            'language_name': 'Tiếng Việt',
                            'is_default': false,
                            'is_active': true,
                          },
                          {
                            'language_code': 'ja',
                            'language_name': 'Japanese',
                            'is_default': false,
                            'is_active': true,
                          },
                        ],
                      },
                    },
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
              return handler.resolve(
                Response(
                  requestOptions: options,
                  data: {'success': true, 'data': {}},
                  statusCode: 200,
                ),
              );
            },
          ),
        );
      },
    );

    // Wait for Splash animation and navigation to settle
    for (int i = 0; i < 15; i++) {
      await tester.pump(const Duration(milliseconds: 300));
    }
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
