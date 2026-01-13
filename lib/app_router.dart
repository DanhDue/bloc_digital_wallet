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
import 'features/settings/presentation/settings/settings_page.dart';
import 'features/settings/presentation/profile/profile_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: ProfileRoute.page, path: '/profile'),
    AutoRoute(page: SettingsRoute.page, path: '/settings'),
    AutoRoute(page: TrendsRoute.page, path: '/trends'),
    AutoRoute(page: TransactionRoute.page, path: '/transaction'),
    AutoRoute(page: WalletRoute.page, path: '/wallet'),
    AutoRoute(page: ScannerRoute.page, path: '/scanner'),
    AutoRoute(page: HomeRoute.page, path: '/home'),
    AutoRoute(page: LoginRoute.page, initial: true),
    AutoRoute(page: RegisterRoute.page, path: '/register'),
    AutoRoute(page: ForgotPasswordRoute.page, path: '/forgot-password'),
    AutoRoute(page: CodeVerificationRoute.page, path: '/verify-code'),
  ];
}
