// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/authentication_repository.dart';

@injectable
class ForgotPasswordUseCase {
  final AuthenticationRepository _repository;

  const ForgotPasswordUseCase(this._repository);

  Future<Either<Failure, void>> call(String email) async {
    // Validate email format
    if (email.isEmpty) {
      return const Left(ValidationFailure(message: 'Email address is required'));
    }

    // Basic email format validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return const Left(ValidationFailure(message: 'Please enter a valid email address'));
    }

    return await _repository.sendPasswordResetEmail(email: email);
  }
}
