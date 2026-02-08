// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wallet/domain/entities/wallet_entity.dart';
import 'package:wallet/domain/repositories/wallet_repository.dart';
import 'package:wallet/domain/usecases/get_wallet_usecase.dart';
import 'package:core/core.dart' hide test;

import 'get_wallet_usecase_test.mocks.dart';

@GenerateMocks([WalletRepository])
void main() {
  late GetWalletUseCase useCase;
  late MockWalletRepository mockRepository;

  setUp(() {
    mockRepository = MockWalletRepository();
    useCase = GetWalletUseCase(mockRepository);
  });

  const tWalletEntity = WalletEntity(
    id: '1',
    name: 'Test Wallet',
    description: 'Test Description',
  );

  test('should get wallet from the repository', () async {
    // arrange
    when(mockRepository.getWallet()).thenAnswer((_) async => Right(tWalletEntity));

    // act
    final result = await useCase();

    // assert
    expect(result, Right(tWalletEntity));
    verify(mockRepository.getWallet());
    verifyNoMoreInteractions(mockRepository);
  });
}
