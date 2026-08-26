// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/widgets.dart';
import 'package:logger/d3nexus_logger.dart';

/// Wraps a [delegate] [NavigatorObserver], forwarding each callback only
/// when [module]'s toggle is currently enabled, checked live via
/// [D3NexusLogger.isModuleEnabled] on every call.
///
/// `TalkerRouteObserver` (from `talker_flutter`) writes directly to
/// `Talker` -- like `TalkerDioLogger`/`TalkerBlocObserver`, it's a
/// third-party observer, not an `ILogAppender`, so it never goes through
/// `D3NexusLogger`/`LogManagerImpl`'s dispatch on its own. This wrapper is
/// what makes a module toggle apply to it live, with no app restart
/// required, same pattern as `ModuleGatedInterceptor`/
/// `ModuleGatedBlocObserver`.
class ModuleGatedRouteObserver extends NavigatorObserver {
  ModuleGatedRouteObserver({required this.module, required this.delegate});

  /// The module whose live toggle gates [delegate].
  final String module;

  /// The observer to forward to when [module] is enabled.
  final NavigatorObserver delegate;

  bool get _enabled => D3NexusLogger.isModuleEnabled(module);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (_enabled) delegate.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (_enabled) delegate.didPop(route, previousRoute);
  }
}
