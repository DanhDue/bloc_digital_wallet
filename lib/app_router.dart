// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:auto_route/auto_route.dart';
import 'package:authentication/authentication.dart' as auth;
import 'package:onboard/onboard.dart' as onboard;
import 'package:scanner/scanner.dart' as scanner;
import 'package:trends/trends.dart' as trends;
import 'package:wallet/wallet.dart' as wallet;
import 'package:transaction/transaction.dart' as transaction;
import 'package:settings/settings.dart' as settings;

import 'package:bloc_digital_wallet/shell/shell_page.dart';

// Export only the router from authentication package to expose LoginRoute
// without causing translation class conflicts.
export 'package:authentication/authentication_router.dart';
export 'package:onboard/onboard_router.dart';
export 'package:scanner/scanner_router.dart';
export 'package:trends/trends_router.dart';
export 'package:wallet/wallet_router.dart';
export 'package:transaction/transaction_router.dart';
export 'package:settings/settings_router.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  final _authRouter = auth.AuthenticationRouter();
  final _scannerRouter = scanner.ScannerRouter();
  final _trendsRouter = trends.TrendsRouter();
  final _walletRouter = wallet.WalletRouter();
  final _transactionRouter = transaction.TransactionRouter();
  final _settingsRouter = settings.SettingsRouter();
  @override
  List<AutoRoute> get routes => [
    AutoRoute(initial: true, page: onboard.SplashRoute.page, path: AppRoutes.splash),
    ..._authRouter.routes,
    AutoRoute(page: ShellRoute.page, path: AppRoutes.home),
    ..._scannerRouter.routes,
    ..._trendsRouter.routes,
    ..._walletRouter.routes,
    ..._transactionRouter.routes,
    ..._settingsRouter.routes,
  ];
}

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String settings = '/settings';
  // Path stays '/home'; the page/route class is ShellRoute (Task 15 renamed
  // the Home* identifiers to Shell* internally, but the public path and
  // DeepLinkRoutes.home/.homeRoute names are unchanged deliberately).
  static const String home = '/home';
}
