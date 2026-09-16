// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:authentication/authentication.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart' hide test;
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockLoginWithEmailPasswordUseCase extends Mock implements LoginWithEmailPasswordUseCase {
  @override
  Future<Either<Failure, AuthUserEntity>> call({
    required String email,
    required String password,
  }) =>
      super.noSuchMethod(
            Invocation.method(#call, [], {#email: email, #password: password}),
            returnValue: Future.value(
              const Right<Failure, AuthUserEntity>(
                AuthUserEntity(id: 'u1', email: 'test@wallet.com'),
              ),
            ),
          )
          as Future<Either<Failure, AuthUserEntity>>;
}

void main() {
  late MockLoginWithEmailPasswordUseCase mockUseCase;
  late LoginBloc loginBloc;

  setUp(() {
    mockUseCase = MockLoginWithEmailPasswordUseCase();
    loginBloc = LoginBloc(mockUseCase);
  });

  tearDown(() {
    loginBloc.close();
  });

  const tUser = AuthUserEntity(id: 'u1', email: 'test@wallet.com');

  group('LoginBloc Tests', () {
    test('initial state is LoginInitial', () {
      expect(loginBloc.state, equals(const LoginInitial()));
    });

    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginSuccess] and navigates to home when login succeeds',
      build: () {
        when(
          mockUseCase.call(email: 'test@wallet.com', password: 'password123'),
        ).thenAnswer((_) => Future<Either<Failure, AuthUserEntity>>.value(const Right(tUser)));
        return loginBloc;
      },
      act: (bloc) => bloc.onAction(
        const LoginWithEmailPasswordAction(email: 'test@wallet.com', password: 'password123'),
      ),
      expect: () => [const LoginLoading(), const LoginSuccess(tUser)],
      verify: (_) {
        verify(mockUseCase.call(email: 'test@wallet.com', password: 'password123')).called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginError] when login fails with Unauthorized error',
      build: () {
        when(mockUseCase.call(email: 'test@wallet.com', password: 'wrong_password')).thenAnswer(
          (_) => Future<Either<Failure, AuthUserEntity>>.value(
            const Left(ServerFailure(message: 'Invalid credentials')),
          ),
        );
        return loginBloc;
      },
      act: (bloc) => bloc.onAction(
        const LoginWithEmailPasswordAction(email: 'test@wallet.com', password: 'wrong_password'),
      ),
      expect: () => [const LoginLoading(), const LoginError('Invalid credentials')],
      verify: (_) {
        verify(mockUseCase.call(email: 'test@wallet.com', password: 'wrong_password')).called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginError] when usecase returns ValidationFailure',
      build: () {
        when(mockUseCase.call(email: '', password: '')).thenAnswer(
          (_) => Future<Either<Failure, AuthUserEntity>>.value(
            const Left(ValidationFailure(message: 'Email is required')),
          ),
        );
        return loginBloc;
      },
      act: (bloc) => bloc.onAction(const LoginWithEmailPasswordAction(email: '', password: '')),
      expect: () => [const LoginLoading(), const LoginError('Email is required')],
    );
  });
}
