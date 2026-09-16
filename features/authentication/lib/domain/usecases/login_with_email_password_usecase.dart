// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:core/core.dart';
import '../entities/auth_user_entity.dart';
import '../repositories/authentication_repository.dart';

@lazySingleton
class LoginWithEmailPasswordUseCase {
  final AuthenticationRepository repository;

  LoginWithEmailPasswordUseCase(this.repository);

  Future<Either<Failure, AuthUserEntity>> call({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Email is required'));
    }

    // Minimal email check; adjust as needed.
    if (!email.contains('@')) {
      return const Left(ValidationFailure(message: 'Invalid email'));
    }

    if (password.isEmpty) {
      return const Left(ValidationFailure(message: 'Password is required'));
    }

    return repository.loginWithEmailPassword(email: email.trim(), password: password);
  }
}
