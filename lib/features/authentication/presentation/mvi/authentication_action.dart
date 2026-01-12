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

class RegisterWithEmailAction extends AuthenticationAction {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final DateTime dateOfBirth;

  const RegisterWithEmailAction({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.dateOfBirth,
  });
}

class ForgotPasswordAction extends AuthenticationAction {
  final String email;

  const ForgotPasswordAction(this.email);
}
