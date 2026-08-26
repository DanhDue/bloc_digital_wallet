// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:bloc_digital_wallet/logging/module_gated_route_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';

class _SpyNavigatorObserver extends NavigatorObserver {
  int didPushCalls = 0;
  int didPopCalls = 0;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    didPushCalls++;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    didPopCalls++;
  }
}

class _FakeLogManager implements ILogManager {
  final Map<String, bool> moduleToggles = <String, bool>{};

  @override
  void setModuleEnabled(String module, bool enabled) => moduleToggles[module] = enabled;

  @override
  bool isModuleEnabled(String module) => moduleToggles[module] ?? true;

  @override
  ILogger getLogger(String module) => throw UnimplementedError();

  @override
  void registerAppender(ILogAppender appender) => throw UnimplementedError();

  @override
  void log(LogRecord record) => throw UnimplementedError();

  @override
  void setAppenderEnabled(String appenderId, bool enabled) => throw UnimplementedError();
}

void main() {
  late _SpyNavigatorObserver delegate;
  late _FakeLogManager manager;
  late ModuleGatedRouteObserver observer;
  late PageRouteBuilder<void> route;

  setUp(() {
    delegate = _SpyNavigatorObserver();
    manager = _FakeLogManager();
    D3NexusLogger.initialize(manager);
    observer = ModuleGatedRouteObserver(module: 'App', delegate: delegate);
    route = PageRouteBuilder<void>(
      settings: const RouteSettings(name: '/wallet'),
      pageBuilder: (context, animation, secondaryAnimation) => const SizedBox(),
    );
  });

  test('when App is enabled, didPush forwards to the delegate', () {
    observer.didPush(route, null);
    expect(delegate.didPushCalls, 1);
  });

  test('when App is enabled, didPop forwards to the delegate', () {
    observer.didPop(route, null);
    expect(delegate.didPopCalls, 1);
  });

  group('when App is disabled', () {
    setUp(() => manager.setModuleEnabled('App', false));

    test('didPush does not forward to the delegate', () {
      observer.didPush(route, null);
      expect(delegate.didPushCalls, 0);
    });

    test('didPop does not forward to the delegate', () {
      observer.didPop(route, null);
      expect(delegate.didPopCalls, 0);
    });
  });

  test('re-enabling after a disable takes effect on the very next call, live', () {
    manager.setModuleEnabled('App', false);
    observer.didPush(route, null);
    expect(delegate.didPushCalls, 0);

    manager.setModuleEnabled('App', true);
    observer.didPush(route, null);
    expect(delegate.didPushCalls, 1);
  });
}
