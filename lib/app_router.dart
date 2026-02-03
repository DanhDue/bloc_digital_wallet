// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

export 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(initial: true, page: SplashRoute.page, path: AppRoutes.splash),
    AutoRoute(page: LoginRoute.page, path: AppRoutes.login),
  ];
}

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
}
