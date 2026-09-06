// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:auto_route/auto_route.dart';
import 'package:scanner/scanner.dart' as scanner;
import 'package:settings/settings.dart' as settings;

import 'package:bloc_digital_wallet/shell/shell_page.dart';

export 'package:scanner/scanner_router.dart';
export 'package:settings/settings_router.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  final _scannerRouter = scanner.ScannerRouter();
  final _settingsRouter = settings.SettingsRouter();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(initial: true, page: ShellRoute.page, path: AppRoutes.home),
    ..._scannerRouter.routes,
    ..._settingsRouter.routes,
  ];
}

class AppRoutes {
  static const String home = '/home';
  static const String scanner = '/scanner';
  static const String settings = '/settings';
}
