// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:transaction/domain/entities/transaction_entity.dart';
import 'package:transaction/domain/repositories/transaction_repository.dart';
import 'package:transaction/domain/usecases/get_transaction_usecase.dart';
import 'package:core/core.dart' hide test;

import 'get_transaction_usecase_test.mocks.dart';

@GenerateMocks([TransactionRepository])
void main() {
  late GetTransactionUseCase useCase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = GetTransactionUseCase(mockRepository);
  });

  const tTransactionEntity = TransactionEntity(
    id: '1',
    name: 'Test Transaction',
    description: 'Test Description',
  );

  test('should get transaction from the repository', () async {
    // arrange
    when(mockRepository.getTransaction()).thenAnswer((_) async => Right(tTransactionEntity));

    // act
    final result = await useCase();

    // assert
    expect(result, Right(tTransactionEntity));
    verify(mockRepository.getTransaction());
    verifyNoMoreInteractions(mockRepository);
  });
}
