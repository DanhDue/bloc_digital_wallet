// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:home/presentation/home/home_page.dart';

part 'home_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class HomeRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [AutoRoute(page: HomeRoute.page, path: HomeRoutes.home)];
}

class HomeRoutes {
  static const String home = '/home';
}
