// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trends/domain/entities/coin_market_entity.dart';
import 'package:trends/domain/repositories/trends_repository.dart';
import 'package:trends/domain/usecases/get_coin_markets_usecase.dart';
import 'package:core/core.dart' hide test;

import 'get_coin_markets_usecase_test.mocks.dart';

@GenerateMocks([TrendsRepository])
void main() {
  late GetCoinMarketsUseCase useCase;
  late MockTrendsRepository mockRepository;

  setUp(() {
    mockRepository = MockTrendsRepository();
    useCase = GetCoinMarketsUseCase(mockRepository);
  });

  final tCoinMarketEntities = [
    const CoinMarketEntity(id: 1, name: 'Bitcoin', symbol: 'BTC', price: 50000),
    const CoinMarketEntity(id: 2, name: 'Ethereum', symbol: 'ETH', price: 3000),
  ];

  test('should call repository.getCoinMarkets with correct pagination params', () async {
    // arrange
    when(
      mockRepository.getCoinMarkets(page: anyNamed('page'), limit: anyNamed('limit')),
    ).thenAnswer((_) async => Right(tCoinMarketEntities));

    // act
    final result = await useCase(page: 2, limit: 10);

    // assert
    verify(mockRepository.getCoinMarkets(page: 2, limit: 10));
    expect(result, Right(tCoinMarketEntities));
  });

  test('should return failure when repository fails', () async {
    // arrange
    when(
      mockRepository.getCoinMarkets(page: anyNamed('page'), limit: anyNamed('limit')),
    ).thenAnswer((_) async => Left(const UnknownFailure(message: 'Error')));

    // act
    final result = await useCase(page: 1, limit: 20);

    // assert
    expect(result, isA<Left>());
  });
}
