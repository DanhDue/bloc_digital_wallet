// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:app_platform/platform.dart';
import 'package:d3_nexus_shield/shell/shell_action.dart';
import 'package:d3_nexus_shield/shell/shell_bloc.dart';

/// Type definition for custom route resolvers mapping a [DeepLinkPayload] to [PageRouteInfo].
typedef RouteResolver = PageRouteInfo Function(DeepLinkPayload payload);

/// Hybrid navigation coordinator executing deep-link requests against either
/// the Host Shell tabs (`ShellBloc`) or modal/sub-page routes (`AppRouter`).
class DeepLinkNavigator {
  final ShellBloc Function() _shellBlocProvider;
  final StackRouter _appRouter;
  final Map<String, RouteResolver> _routeResolvers;

  DeepLinkNavigator({
    required ShellBloc Function() shellBlocProvider,
    required StackRouter appRouter,
    Map<String, RouteResolver>? routeResolvers,
  }) : _shellBlocProvider = shellBlocProvider,
       _appRouter = appRouter,
       _routeResolvers = routeResolvers ?? const {};

  /// Navigates to the destination represented by [payload].
  ///
  /// - If [payload.isFallback] is true: falls back to Root Tab 0 (Home).
  /// - If [payload.targetTab] is specified or route maps to a root tab in [DeepLinkRegistry]:
  ///   switches tab in-place via [ShellBloc].
  /// - If a custom [RouteResolver] exists for the route: pushes the route onto [_appRouter].
  /// - Otherwise: safely falls back to Root Tab 0 without crashing.
  Future<void> navigate(DeepLinkPayload payload) async {
    if (payload.isFallback) {
      _shellBlocProvider().onAction(const ShellAction.tabChanged(0));
      return;
    }

    // 1. Check if payload directly carries a target tab index
    final tabIndex = payload.targetTab ?? DeepLinkRegistry.getTabIndex(payload.path);
    if (tabIndex != null) {
      _shellBlocProvider().onAction(ShellAction.tabChanged(tabIndex));
      return;
    }

    // 2. Check if route is a sub-page or modal route registered in routeResolvers
    final resolver = _routeResolvers[payload.path];
    if (resolver != null) {
      final pageRoute = resolver(payload);
      await _appRouter.push(pageRoute);
      return;
    }

    // 3. Unrecognized or unmapped route: fallback to Home tab 0 gracefully
    _shellBlocProvider().onAction(const ShellAction.tabChanged(0));
  }
}
