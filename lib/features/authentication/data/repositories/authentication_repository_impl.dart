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
    return await remote.loginWithEmailPassword(email: email, password: password);
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
    return await remote.registerWithEmail(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
    );
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail({required String email}) async {
    return await remote.sendPasswordResetEmail(email: email);
  }

  @override
  Future<Either<Failure, void>> verifyResetCode({required String code}) async {
    return await remote.verifyResetCode(code: code);
  }
}
