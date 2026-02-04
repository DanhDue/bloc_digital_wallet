// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

/// Contains UI-specific state that may differ from domain entities.

class LoginUiModel {
  final String email;
  final String password;
  final bool rememberMe;
  final String? emailError;
  final String? passwordError;

  const LoginUiModel({
    this.email = '',
    this.password = '',
    this.rememberMe = false,
    this.emailError,
    this.passwordError,
  });

  LoginUiModel copyWith({
    String? email,
    String? password,
    bool? rememberMe,
    String? emailError,
    String? passwordError,
  }) {
    return LoginUiModel(
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
    );
  }
}
