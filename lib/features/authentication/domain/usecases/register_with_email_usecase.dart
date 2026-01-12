// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/auth_user_entity.dart';
import '../repositories/authentication_repository.dart';

@injectable
class RegisterWithEmailUseCase {
  final AuthenticationRepository repository;

  RegisterWithEmailUseCase(this.repository);

  Future<Either<Failure, AuthUserEntity>> call({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required DateTime dateOfBirth,
  }) async {
    // Basic validation
    if (email.isEmpty || !email.contains('@')) {
      return const Left(ValidationFailure(message: 'Please enter a valid email'));
    }

    if (password.length < 6) {
      return const Left(ValidationFailure(message: 'Password must be at least 6 characters'));
    }

    if (firstName.isEmpty) {
      return const Left(ValidationFailure(message: 'First name is required'));
    }

    if (lastName.isEmpty) {
      return const Left(ValidationFailure(message: 'Last name is required'));
    }

    return await repository.registerWithEmail(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
    );
  }
}
