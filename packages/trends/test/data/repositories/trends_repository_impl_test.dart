// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trends/data/datasources/remote/trends_remote_datasource.dart';
import 'package:trends/data/repositories/trends_repository_impl.dart';
import 'package:trends/domain/entities/coin_market_entity.dart';
import 'package:trends/domain/entities/coin_market_ohlcv_entity.dart';

import 'trends_repository_impl_test.mocks.dart';

@GenerateMocks([TrendsRemoteDataSource])
void main() {
  late TrendsRepositoryImpl repository;
  late MockTrendsRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockTrendsRemoteDataSource();
    repository = TrendsRepositoryImpl(mockRemoteDataSource);
  });

  const tCoinMarketEntity = CoinMarketEntity(
    id: 1,
    symbol: 'BTC',
    name: 'Bitcoin',
    price: 50000.0,
  );
  final tCoinMarketList = [tCoinMarketEntity];

  const tOhlcvEntity = CoinMarketOhlcvEntity(
    open: 100.0,
    high: 110.0,
    low: 90.0,
    close: 105.0,
    volume: 1000.0,
  );

  group('getCoinMarkets', () {
    test(
      'should return list of CoinMarketEntity when call to data source is successful',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getCoinMarkets(
            page: anyNamed('page'),
            limit: anyNamed('limit'),
            convert: anyNamed('convert'),
            sort: anyNamed('sort'),
            sortDir: anyNamed('sortDir'),
          ),
        ).thenAnswer((_) async => Right(tCoinMarketList));

        // Act
        final result = await repository.getCoinMarkets();

        // Assert
        expect(result.isRight(), true);
        verify(mockRemoteDataSource.getCoinMarkets(page: 1, limit: 20));
      },
    );
  });

  group('getCoinInfo', () {
    test('should return Map<String, CoinMarketEntity> when successful', () async {
      // Arrange
      final tMap = {'BTC': tCoinMarketEntity};
      when(mockRemoteDataSource.getCoinInfo(symbol: 'BTC')).thenAnswer((_) async => Right(tMap));

      // Act
      final result = await repository.getCoinInfo(symbol: 'BTC');

      // Assert
      expect(result.isRight(), true);
      verify(mockRemoteDataSource.getCoinInfo(symbol: 'BTC'));
    });
  });

  group('getCoinPriceConversion', () {
    test('should return CoinMarketEntity when successful', () async {
      // Arrange
      when(
        mockRemoteDataSource.getCoinPriceConversion(symbol: 'BTC', amount: 1.0, convert: 'USD'),
      ).thenAnswer((_) async => const Right(tCoinMarketEntity));

      // Act
      final result = await repository.getCoinPriceConversion(
        symbol: 'BTC',
        amount: 1.0,
        convert: 'USD',
      );

      // Assert
      expect(result.isRight(), true);
      verify(
        mockRemoteDataSource.getCoinPriceConversion(symbol: 'BTC', amount: 1.0, convert: 'USD'),
      );
    });
  });

  group('getOhlcv', () {
    test('should return Map<String, CoinMarketOhlcvEntity> when successful', () async {
      // Arrange
      final tMap = {'BTC': tOhlcvEntity};
      when(
        mockRemoteDataSource.getOhlcv(symbol: 'BTC', interval: '1d'),
      ).thenAnswer((_) async => Right(tMap));

      // Act
      final result = await repository.getOhlcv(symbol: 'BTC', interval: '1d');

      // Assert
      expect(result.isRight(), true);
      verify(mockRemoteDataSource.getOhlcv(symbol: 'BTC', interval: '1d'));
    });
  });
}
