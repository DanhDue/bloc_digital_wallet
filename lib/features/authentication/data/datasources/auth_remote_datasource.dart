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
      return AuthUserModel(
        id: 'demo-user',
        email: email,
        displayName: 'Demo User',
      );
    }

    throw const AuthInvalidCredentialsException();
  }

  Future<AuthUserModel> registerWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required DateTime dateOfBirth,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    // Demo-only: Check if email already exists
    if (email.toLowerCase() == 'test@test.com') {
      throw const AuthEmailAlreadyExistsException();
    }

    // Demo-only: Create mock user
    return AuthUserModel(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: '$firstName $lastName',
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
    );
  }
}

class AuthInvalidCredentialsException implements Exception {
  const AuthInvalidCredentialsException();
}

class AuthEmailAlreadyExistsException implements Exception {
  const AuthEmailAlreadyExistsException();
}
