// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';

import 'package:injectable/injectable.dart';

import '../models/auth_user_model.dart';

@lazySingleton
class AuthRemoteDataSource {
  // TODO(authentication): Replace with real API (Dio/Retrofit).
  Future<AuthUserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));

    // Demo-only credentials. Replace with real implementation.
    if (password == '123456' || password == 'password') {
      return AuthUserModel(id: 'demo-user', email: email, displayName: 'Demo User');
    }

    throw const AuthInvalidCredentialsException();
  }
}

class AuthInvalidCredentialsException implements Exception {
  const AuthInvalidCredentialsException();
}
