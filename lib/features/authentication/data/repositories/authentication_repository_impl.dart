// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../datasources/auth_remote_datasource.dart';

@LazySingleton(as: AuthenticationRepository)
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthRemoteDataSource remote;

  AuthenticationRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, AuthUserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remote.loginWithEmailPassword(email: email, password: password);
      return Right(user);
    } on AuthInvalidCredentialsException {
      return const Left(AuthenticationFailure(message: 'Invalid email or password'));
    } catch (e) {
      return Left(UnknownFailure(message: 'Login failed', exception: e));
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity>> registerWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required DateTime dateOfBirth,
  }) async {
    try {
      final user = await remote.registerWithEmail(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
      );
      return Right(user);
    } on AuthEmailAlreadyExistsException {
      return const Left(
        AuthenticationFailure(message: 'An account with this email already exists'),
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'Registration failed', exception: e));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail({required String email}) async {
    try {
      await remote.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on AuthEmailNotFoundException {
      return const Left(
        AuthenticationFailure(message: 'No account found with this email address'),
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to send reset email', exception: e));
    }
  }

  @override
  Future<Either<Failure, void>> verifyResetCode({required String code}) async {
    try {
      await remote.verifyResetCode(code: code);
      return const Right(null);
    } on AuthInvalidCodeException {
      return const Left(AuthenticationFailure(message: 'Invalid verification code'));
    } on AuthCodeExpiredException {
      return const Left(
        AuthenticationFailure(message: 'Code has expired. Please request a new one'),
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to verify code', exception: e));
    }
  }
}
