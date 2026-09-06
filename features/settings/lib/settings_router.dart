// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:settings/presentation/settings/settings_page.dart';

part 'settings_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class SettingsRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SettingsRoute.page, path: SettingsRoutes.settings),
  ];
}

class SettingsRoutes {
  static const String settings = '/settings';
}
