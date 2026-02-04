// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:authentication/presentation/login/login_page.dart';

part 'authentication_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AuthenticationRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [AutoRoute(page: LoginRoute.page, path: '/login')];
}
