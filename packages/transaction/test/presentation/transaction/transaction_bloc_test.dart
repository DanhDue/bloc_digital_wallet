// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:transaction/domain/entities/transaction_entity.dart';
import 'package:transaction/domain/usecases/get_transaction_usecase.dart';
import 'package:transaction/presentation/transaction/transaction_action.dart';
import 'package:transaction/presentation/transaction/transaction_bloc.dart';
import 'package:transaction/presentation/transaction/transaction_state.dart';
import 'package:core/core.dart' hide test;

import 'transaction_bloc_test.mocks.dart';

@GenerateMocks([GetTransactionUseCase])
void main() {
  late TransactionBloc bloc;
  late MockGetTransactionUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetTransactionUseCase();
    bloc = TransactionBloc(mockUseCase);
  });

  const tTransactionEntity = TransactionEntity(
    id: '1',
    name: 'Test',
    description: 'Description',
  );

  test('initial state should be initial', () {
    expect(bloc.state.status, TransactionStatus.initial);
  });

  blocTest<TransactionBloc, TransactionState>(
    'emits [loading, success] when started is added and usecase returns success',
    build: () {
      when(mockUseCase()).thenAnswer((_) async => const Right(tTransactionEntity));
      return bloc;
    },
    act: (bloc) => bloc.add(const TransactionAction.started()),
    expect: () => [
      const TransactionState(status: TransactionStatus.loading),
      isA<TransactionState>()
          .having((s) => s.status, 'status', TransactionStatus.success)
          .having((s) => s.uiModel, 'uiModel', isNotNull),
    ],
    verify: (_) {
      verify(mockUseCase());
    },
  );
}
