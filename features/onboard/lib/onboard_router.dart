// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'presentation/splash/splash_page.dart';

part 'onboard_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class OnboardRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [AutoRoute(page: SplashRoute.page)];
}
