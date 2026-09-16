// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:trends/presentation/trends/trends_page.dart';

part 'trends_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class TrendsRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [AutoRoute(page: TrendsRoute.page, path: TrendsRoutes.trends)];
}

class TrendsRoutes {
  static const String trends = '/trends';
}
