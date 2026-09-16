// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:app_platform/deeplink/deep_link_routes.dart';

/// Configuration definition for a registered route in the Super App.
class RouteRegistration {
  final String path;
  final int? targetTab;
  final bool isProtected;

  const RouteRegistration({required this.path, this.targetTab, this.isProtected = false});
}

/// Central registry managing route metadata and tab associations for deep linking.
abstract class DeepLinkRegistry {
  static final Map<String, RouteRegistration> _defaultRegistry = {
    DeepLinkRoutes.home: const RouteRegistration(
      path: DeepLinkRoutes.home,
      targetTab: 0,
      isProtected: false,
    ),
    // deeplink:scanner-register:begin
    DeepLinkRoutes.scanner: const RouteRegistration(
      path: DeepLinkRoutes.scanner,
      targetTab: 1,
      isProtected: false,
    ),
    // deeplink:scanner-register:end
    // deeplink:settings-tab-enterprise:begin
    DeepLinkRoutes.settings: const RouteRegistration(
      path: DeepLinkRoutes.settings,
      targetTab: 2,
      isProtected: false,
    ),
    // deeplink:settings-tab-enterprise:end
    // deeplink:settings-tab-lean:begin
    // DeepLinkRoutes.settings: const RouteRegistration(
    //   path: DeepLinkRoutes.settings,
    //   targetTab: 1,
    //   isProtected: false,
    // ),
    // deeplink:settings-tab-lean:end
    DeepLinkRoutes.splash: const RouteRegistration(
      path: DeepLinkRoutes.splash,
      targetTab: null,
      isProtected: false,
    ),
    DeepLinkRoutes.login: const RouteRegistration(
      path: DeepLinkRoutes.login,
      targetTab: null,
      isProtected: false,
    ),
    DeepLinkRoutes.trends: const RouteRegistration(
      path: DeepLinkRoutes.trends,
      targetTab: null,
      isProtected: true,
    ),
    DeepLinkRoutes.wallet: const RouteRegistration(
      path: DeepLinkRoutes.wallet,
      targetTab: null,
      isProtected: true,
    ),
    DeepLinkRoutes.transaction: const RouteRegistration(
      path: DeepLinkRoutes.transaction,
      targetTab: null,
      isProtected: true,
    ),
    DeepLinkRoutes.onboard: const RouteRegistration(
      path: DeepLinkRoutes.onboard,
      targetTab: null,
      isProtected: false,
    ),
    DeepLinkRoutes.authentication: const RouteRegistration(
      path: DeepLinkRoutes.authentication,
      targetTab: null,
      isProtected: false,
    ),
  };

  static final Map<String, RouteRegistration> _dynamicRegistry = {};

  /// Registers a new route or overrides an existing registration.
  static void registerRoute({required String path, int? targetTab, bool isProtected = false}) {
    final normalizedPath = _normalizePath(path);
    _dynamicRegistry[normalizedPath] = RouteRegistration(
      path: normalizedPath,
      targetTab: targetTab,
      isProtected: isProtected,
    );
  }

  /// Checks if a route path is recognized by the registry.
  static bool isKnownRoute(String path) {
    final normalizedPath = _normalizePath(path);
    return _dynamicRegistry.containsKey(normalizedPath) ||
        _defaultRegistry.containsKey(normalizedPath);
  }

  /// Returns the target tab index for a given route path, if any.
  static int? getTabIndex(String path) {
    final normalizedPath = _normalizePath(path);
    if (_dynamicRegistry.containsKey(normalizedPath)) {
      return _dynamicRegistry[normalizedPath]?.targetTab;
    }
    return _defaultRegistry[normalizedPath]?.targetTab;
  }

  /// Returns whether accessing this route requires authentication.
  static bool isProtected(String path) {
    final normalizedPath = _normalizePath(path);
    if (_dynamicRegistry.containsKey(normalizedPath)) {
      return _dynamicRegistry[normalizedPath]?.isProtected ?? false;
    }
    return _defaultRegistry[normalizedPath]?.isProtected ?? false;
  }

  /// Finds matching RouteRegistration. Checks exact match first, then parent prefix.
  static RouteRegistration? resolve(String path) {
    final normalizedPath = _normalizePath(path);
    if (_dynamicRegistry.containsKey(normalizedPath)) {
      return _dynamicRegistry[normalizedPath];
    }
    if (_defaultRegistry.containsKey(normalizedPath)) {
      return _defaultRegistry[normalizedPath];
    }

    // Check if path is a sub-path of a known root tab (e.g. /settings/languages -> inherits targetTab 2)
    for (final entry in _dynamicRegistry.entries) {
      if (normalizedPath.startsWith('${entry.key}/')) {
        return entry.value;
      }
    }
    for (final entry in _defaultRegistry.entries) {
      if (normalizedPath.startsWith('${entry.key}/')) {
        return entry.value;
      }
    }

    return null;
  }

  /// Normalizes a path ensuring a leading slash and no trailing slash (unless root '/').
  static String _normalizePath(String path) {
    var p = path.trim().toLowerCase();
    if (!p.startsWith('/')) {
      p = '/$p';
    }
    if (p.length > 1 && p.endsWith('/')) {
      p = p.substring(0, p.length - 1);
    }
    return p;
  }

  /// Clears dynamic registrations (used in testing).
  static void reset() {
    _dynamicRegistry.clear();
  }
}
