// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:authentication/authentication.dart';
import 'package:core/core.dart' hide test;
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {
  @override
  Future<Either<Failure, AuthUserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  }) =>
      super.noSuchMethod(
            Invocation.method(#loginWithEmailPassword, [], {#email: email, #password: password}),
            returnValue: Future.value(
              const Right<Failure, AuthUserEntity>(
                AuthUserEntity(id: 'u1', email: 'test@wallet.com'),
              ),
            ),
          )
          as Future<Either<Failure, AuthUserEntity>>;
}

void main() {
  late MockAuthenticationRepository mockRepository;
  late LoginWithEmailPasswordUseCase useCase;

  setUp(() {
    mockRepository = MockAuthenticationRepository();
    useCase = LoginWithEmailPasswordUseCase(mockRepository);
  });

  const tUser = AuthUserEntity(id: 'u1', email: 'test@wallet.com');

  group('LoginWithEmailPasswordUseCase Tests', () {
    test('returns ValidationFailure when email is empty', () async {
      final result = await useCase(email: '   ', password: 'password123');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, equals('Email is required')),
        (_) => fail('should fail'),
      );
      verifyZeroInteractions(mockRepository);
    });

    test('returns ValidationFailure when email does not contain @', () async {
      final result = await useCase(email: 'invalid-email', password: 'password123');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, equals('Invalid email')),
        (_) => fail('should fail'),
      );
      verifyZeroInteractions(mockRepository);
    });

    test('returns ValidationFailure when password is empty', () async {
      final result = await useCase(email: 'test@wallet.com', password: '');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, equals('Password is required')),
        (_) => fail('should fail'),
      );
      verifyZeroInteractions(mockRepository);
    });

    test('calls repository when email and password are valid', () async {
      when(
        mockRepository.loginWithEmailPassword(email: 'test@wallet.com', password: 'password123'),
      ).thenAnswer((_) => Future.value(const Right(tUser)));

      final result = await useCase(email: '  test@wallet.com  ', password: 'password123');

      expect(result, equals(const Right(tUser)));
      verify(
        mockRepository.loginWithEmailPassword(email: 'test@wallet.com', password: 'password123'),
      ).called(1);
    });
  });
}
