// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:auto_route/auto_route.dart';
import 'package:authentication/authentication.dart' as auth;
import 'package:onboard/onboard.dart' as onboard;

export 'app_router.gr.dart';
// Export only the router from authentication package to expose LoginRoute
// without causing translation class conflicts.
export 'package:authentication/authentication_router.dart';
export 'package:onboard/onboard_router.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  final _authRouter = auth.AuthenticationRouter();
  @override
  List<AutoRoute> get routes => [
    AutoRoute(initial: true, page: onboard.SplashRoute.page, path: AppRoutes.splash),
    ..._authRouter.routes,
  ];
}

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
}
