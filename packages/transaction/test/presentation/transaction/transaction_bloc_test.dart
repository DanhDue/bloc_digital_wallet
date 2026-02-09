// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:transaction/domain/entities/transaction_entity.dart';
import 'package:transaction/domain/usecases/get_transactions_by_owner_usecase.dart';
import 'package:transaction/presentation/transaction/transaction_action.dart';
import 'package:transaction/presentation/transaction/bloc/transaction_bloc.dart';
import 'package:transaction/presentation/transaction/transaction_state.dart';

import 'transaction_bloc_test.mocks.dart';

@GenerateMocks([GetTransactionsByOwnerUseCase])
void main() {
  late TransactionBloc bloc;
  late MockGetTransactionsByOwnerUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetTransactionsByOwnerUseCase();
    bloc = TransactionBloc(mockUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  const tTransaction = TransactionEntity(signature: 'sig1');
  final tTransactions = [tTransaction];

  test('initial state should be initial', () {
    expect(bloc.state, const TransactionState());
  });

  blocTest<TransactionBloc, TransactionState>(
    'emits [loading, success] with items when started is added',
    build: () {
      when(
        mockUseCase(any, limit: anyNamed('limit'), before: anyNamed('before')),
      ).thenAnswer((_) async => Right(tTransactions));
      return bloc;
    },
    act: (bloc) => bloc.add(const TransactionAction.started()),
    expect: () => [
      const TransactionState(isLoading: true, items: []),
      isA<TransactionState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.items, 'items', isNotEmpty)
          .having((s) => s.hasReachedMax, 'hasReachedMax', true),
    ],
    verify: (_) {
      verify(mockUseCase(any, limit: anyNamed('limit'), before: anyNamed('before'))).called(1);
    },
  );
}
