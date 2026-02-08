// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';

/// Common routes for cross-package navigation.
/// Contains initial/entry routes for each package.
/// This avoids direct package dependencies for navigation.
abstract class FeaturePublicRoutes {
  // Onboard
  static const String splash = '/splash';
  static const PageRouteInfo splashRoute = _SplashRoute();

  // Authentication
  static const String login = '/login';
  static const PageRouteInfo loginRoute = _LoginRoute();

  // Settings
  static const String settings = '/settings';
  static const PageRouteInfo settingsRoute = _SettingsRoute();

  // Home
  static const String home = '/home';
  static const PageRouteInfo homeRoute = _HomeRoute();
}

// Private route classes for type-safe navigation without importing package routers
class _SplashRoute extends PageRouteInfo<void> {
  const _SplashRoute() : super('SplashRoute');
}

class _LoginRoute extends PageRouteInfo<void> {
  const _LoginRoute() : super('LoginRoute');
}

class _SettingsRoute extends PageRouteInfo<void> {
  const _SettingsRoute() : super('SettingsRoute');
}

class _HomeRoute extends PageRouteInfo<void> {
  const _HomeRoute() : super('HomeRoute');
}
