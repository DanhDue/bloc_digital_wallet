// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
// app:scanner-import:begin
import 'package:scanner/scanner.dart' as scanner;
export 'package:scanner/scanner_router.dart';
// app:scanner-import:end
import 'package:settings/settings.dart' as settings;
import 'package:onboard/onboard.dart' as onboard;

import 'package:d3_nexus_shield/shell/shell_page.dart';

export 'package:settings/settings_router.dart';
export 'package:onboard/onboard_router.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  // app:scanner-router:begin
  final _scannerRouter = scanner.ScannerRouter();
  // app:scanner-router:end
  final _settingsRouter = settings.SettingsRouter();
  final _onboardRouter = onboard.OnboardRouter();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(initial: true, page: ShellRoute.page, path: AppRoutes.home),
    // app:scanner-routes:begin
    ..._scannerRouter.routes,
    // app:scanner-routes:end
    ..._settingsRouter.routes,
    ..._onboardRouter.routes,
  ];
}

class AppRoutes {
  static const String home = '/home';
  static const String scanner = '/scanner';
  static const String settings = '/settings';
}
