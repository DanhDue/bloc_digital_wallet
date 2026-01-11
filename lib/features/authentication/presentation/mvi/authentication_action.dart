// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

sealed class AuthenticationAction extends BaseAction {
  const AuthenticationAction();
}

class LoginWithEmailPasswordAction extends AuthenticationAction {
  final String email;
  final String password;

  const LoginWithEmailPasswordAction({required this.email, required this.password});
}
