// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wallet/domain/entities/wallet_entity.dart';
import 'package:wallet/domain/usecases/get_wallet_usecase.dart';
import 'package:wallet/presentation/wallet/wallet_action.dart';
import 'package:wallet/presentation/wallet/wallet_bloc.dart';
import 'package:wallet/presentation/wallet/wallet_state.dart';
import 'package:core/core.dart' hide test;

import 'wallet_bloc_test.mocks.dart';

@GenerateMocks([GetWalletUseCase])
void main() {
  late WalletBloc bloc;
  late MockGetWalletUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetWalletUseCase();
    bloc = WalletBloc(mockUseCase);
  });

  const tWalletEntity = WalletEntity(id: '1', name: 'Test', description: 'Description');

  test('initial state should be initial', () {
    expect(bloc.state.status, WalletStatus.initial);
  });

  blocTest<WalletBloc, WalletState>(
    'emits [loading, success] when started is added and usecase returns success',
    build: () {
      when(mockUseCase()).thenAnswer((_) async => const Right(tWalletEntity));
      return bloc;
    },
    act: (bloc) => bloc.add(const WalletAction.started()),
    expect: () => [
      const WalletState(status: WalletStatus.loading),
      isA<WalletState>()
          .having((s) => s.status, 'status', WalletStatus.success)
          .having((s) => s.uiModel, 'uiModel', isNotNull),
    ],
    verify: (_) {
      verify(mockUseCase());
    },
  );
}
