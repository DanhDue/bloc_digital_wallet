// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/authentication_repository.dart';

@injectable
class VerifyCodeUseCase {
  final AuthenticationRepository _repository;

  const VerifyCodeUseCase(this._repository);

  Future<Either<Failure, void>> call(String code) async {
    // Validate code format (5 digits)
    if (code.isEmpty) {
      return const Left(ValidationFailure(message: 'Verification code is required'));
    }

    if (code.length != 5 || !RegExp(r'^\d{5}$').hasMatch(code)) {
      return const Left(ValidationFailure(message: 'Please enter a valid 5-digit code'));
    }

    return await _repository.verifyResetCode(code: code);
  }
}
