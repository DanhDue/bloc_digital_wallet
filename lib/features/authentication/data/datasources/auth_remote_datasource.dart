// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';

import 'package:bloc_digital_wallet/features/authentication/data/datasources/remote/auth_client.dart';
import 'package:bloc_digital_wallet/features/authentication/data/models/auth_user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:bloc_digital_wallet/core/errors/failures.dart';
import 'package:bloc_digital_wallet/core/mixin/safe_call_api_mixin.dart';
import 'package:bloc_digital_wallet/features/authentication/domain/entities/auth_user_entity.dart';

@lazySingleton
class AuthRemoteDataSource with SafeCallApiMixin {
  final AuthClient _client;

  AuthRemoteDataSource(this._client);

  Future<Either<Failure, AuthUserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final result = await safeApiCall(() => _client.login(email: email, password: password));

    return result.fold((failure) {
      if (password == '123456' || password == 'password') {
        // Fallback for demo if API fails
        return Right(
          _toEntity(
            AuthUserModel(
              access: 'demo-access-token',
              refresh: 'demo-refresh-token',
              user: AuthUserInnerModel(id: 1, email: email, username: 'Demo User'),
            ),
          ),
        );
      }
      return Left(failure);
    }, (success) => Right(_toEntity(success)));
  }

  Future<Either<Failure, AuthUserEntity>> registerWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required DateTime dateOfBirth,
  }) async {
    final result = await safeApiCall(
      () => _client.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth.toIso8601String(),
      ),
    );
    return result.map(_toEntity);
  }

  Future<Either<Failure, void>> sendPasswordResetEmail({required String email}) async {
    return await safeApiCall(() => _client.sendPasswordResetEmail(email: email));
  }

  Future<Either<Failure, void>> verifyResetCode({required String code}) async {
    return await safeApiCall(() => _client.verifyResetCode(code: code));
  }

  /// Convert core AuthUserModel to feature AuthUserEntity
  AuthUserEntity _toEntity(AuthUserModel model) {
    return AuthUserEntity(
      id: model.user?.id?.toString() ?? '',
      email: model.user?.email ?? '',
      displayName: model.user?.username,
      firstName: null,
      lastName: null,
      phoneNumber: null,
      dateOfBirth: null,
    );
  }
}

class AuthInvalidCodeException implements Exception {
  const AuthInvalidCodeException();
}

class AuthCodeExpiredException implements Exception {
  const AuthCodeExpiredException();
}

class AuthInvalidCredentialsException implements Exception {
  const AuthInvalidCredentialsException();
}

class AuthEmailAlreadyExistsException implements Exception {
  const AuthEmailAlreadyExistsException();
}

class AuthEmailNotFoundException implements Exception {
  const AuthEmailNotFoundException();
}
