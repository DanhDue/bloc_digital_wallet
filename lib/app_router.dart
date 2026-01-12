// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:auto_route/auto_route.dart';

import 'features/authentication/presentation/forgot_password/forgot_password_page.dart';
import 'features/authentication/presentation/code_verification/code_verification_page.dart';
import 'features/authentication/presentation/login/login_page.dart';
import 'features/authentication/presentation/register/register_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, initial: true),
    AutoRoute(page: RegisterRoute.page, path: '/register'),
    AutoRoute(page: ForgotPasswordRoute.page, path: '/forgot-password'),
    AutoRoute(page: CodeVerificationRoute.page, path: '/verify-code'),
  ];
}
