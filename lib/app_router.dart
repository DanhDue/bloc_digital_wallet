// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:auto_route/auto_route.dart';

import 'core/utils/route_utils.dart';

import 'app_router.gr.dart';
export 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: NftsListRoute.page, path: AppRoutes.nftsList),
    AutoRoute(page: TokenListRoute.page, path: AppRoutes.tokenList),
    AutoRoute(page: WalletListRoute.page, path: AppRoutes.walletList),
    CustomRoute(
      page: NetworkSelectionRoute.page,
      path: AppRoutes.networkSelection,
      customRouteBuilder: modalSheetBuilder,
    ),
    AutoRoute(page: StartRoute.page, path: AppRoutes.start),
    AutoRoute(initial: true, page: SplashRoute.page, path: AppRoutes.splash),
    AutoRoute(page: OnboardRoute.page, path: AppRoutes.onboard),
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
    AutoRoute(page: LoginRoute.page, path: AppRoutes.login),
    AutoRoute(page: RegisterRoute.page, path: AppRoutes.register),
    AutoRoute(page: ForgotPasswordRoute.page, path: AppRoutes.forgotPassword),
    AutoRoute(page: CodeVerificationRoute.page, path: AppRoutes.verifyCode),
    AutoRoute(page: TalkerRoute.page, path: AppRoutes.talker),
  ];
}

class AppRoutes {
  static const String nftsList = '/nfts-list';
  static const String tokenList = '/token-list';
  static const String walletList = '/wallet-list';
  static const String networkSelection = '/network-selection';
  static const String trends = 'trends';
  static const String transaction = 'transaction';
  static const String wallet = 'wallet';
  static const String start = '/start';
  static const String splash = '/splash';
  static const String onboard = '/onboard';
  static const String home = '/home';
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
