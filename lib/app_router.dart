// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:auto_route/auto_route.dart';
import 'features/home/presentation/home/home_page.dart';
import 'features/scanner/presentation/scanner/scanner_page.dart';
import 'features/wallet/presentation/wallet/wallet_page.dart';
import 'features/transaction/presentation/transaction/transaction_page.dart';
import 'features/trends/presentation/trends/trends_page.dart';
import 'features/authentication/presentation/forgot_password/forgot_password_page.dart';
import 'features/authentication/presentation/code_verification/code_verification_page.dart';
import 'features/authentication/presentation/login/login_page.dart';
import 'features/authentication/presentation/register/register_page.dart';
import 'features/dashboard/presentation/dashboard/dashboard_page.dart';
import 'features/settings/presentation/settings/settings_page.dart';
import 'features/settings/presentation/profile/profile_page.dart';
import 'features/settings/presentation/settings/settings_tab_page.dart';
import 'features/settings/presentation/talker/talker_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: HomeRoute.page,
      path: AppRoutes.home,
      children: [
        AutoRoute(page: WalletRoute.page, path: AppRoutes.wallet),
        AutoRoute(page: TransactionRoute.page, path: AppRoutes.transaction),
        AutoRoute(page: TrendsRoute.page, path: AppRoutes.trends),
        AutoRoute(
          page: SettingsTabRoute.page,
          path: AppRoutes.settingsTab,
          children: [
            AutoRoute(page: SettingsRoute.page, path: ''),
            AutoRoute(page: ProfileRoute.page, path: AppRoutes.profile),
          ],
        ),
      ],
    ),
    AutoRoute(page: DashboardRoute.page, path: AppRoutes.dashboard),
    AutoRoute(page: ScannerRoute.page, path: AppRoutes.scanner),
    AutoRoute(page: LoginRoute.page, path: AppRoutes.login, initial: true),
    AutoRoute(page: RegisterRoute.page, path: AppRoutes.register),
    AutoRoute(page: ForgotPasswordRoute.page, path: AppRoutes.forgotPassword),
    AutoRoute(page: CodeVerificationRoute.page, path: AppRoutes.verifyCode),
    AutoRoute(page: TalkerRoute.page, path: AppRoutes.talker),
  ];
}

class AppRoutes {
  static const String home = '/home';
  static const String wallet = 'wallet';
  static const String transaction = 'transaction';
  static const String trends = 'trends';
  static const String settingsTab = 'settings-tab';
  static const String profile = 'profile';
  static const String dashboard = '/dashboard';
  static const String scanner = '/scanner';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String verifyCode = '/verify-code';
  static const String talker = '/talker';
}
