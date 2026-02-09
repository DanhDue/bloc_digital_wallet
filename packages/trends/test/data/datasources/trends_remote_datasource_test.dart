// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart' hide test;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:trends/data/datasources/remote/trends_client.dart';
import 'package:trends/data/datasources/remote/trends_remote_datasource.dart';
import 'package:trends/data/models/coin_market_model.dart';
import 'package:trends/data/models/coin_market_ohlcv_model.dart';

import 'package:trends/data/models/coin_market_response.dart';

import 'trends_remote_datasource_test.mocks.dart';

@GenerateMocks(
  [TrendsClient],
  customMocks: [
    MockSpec<Talker>(as: #MockTalker, unsupportedMembers: {#configure}),
  ],
)
void main() {
  late TrendsRemoteDataSource dataSource;
  late MockTrendsClient mockClient;
  late MockTalker mockTalker;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    const MethodChannel channel = MethodChannel('dev.fluttercommunity.plus/connectivity');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return ['wifi']; // Return list of strings for connectivity_plus >= 6.0.0
      },
    );
  });

  setUp(() {
    mockTalker = MockTalker();
    GetIt.I.registerSingleton<Talker>(mockTalker);
    mockClient = MockTrendsClient();
    dataSource = TrendsRemoteDataSource(mockClient);
  });

  tearDown(() {
    GetIt.I.reset();
  });

  const tCoinMarketModel = CoinMarketModel(id: 1, symbol: 'BTC', name: 'Bitcoin', price: 50000.0);
  final tCoinMarketList = <CoinMarketModel>[tCoinMarketModel];
  final tCoinMarketResponse = CoinMarketResponse(data: tCoinMarketList, status: null);

  const tOhlcvModel = CoinMarketOhlcvModel(
    open: 100.0,
    high: 110.0,
    low: 90.0,
    close: 105.0,
    volume: 1000.0,
  );

  group('getCoinMarkets', () {
    test('should return list of CoinMarketEntity when call to client is successful', () async {
      // Arrange
      when(
        mockClient.getCoinMarkets(
          start: anyNamed('start'),
          limit: anyNamed('limit'),
          convert: anyNamed('convert'),
          sort: anyNamed('sort'),
          sortDir: anyNamed('sortDir'),
        ),
      ).thenAnswer((_) async => tCoinMarketResponse);

      // Act
      final result = await dataSource.getCoinMarkets();

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Expected success'), (entities) {
        expect(entities.length, 1);
        expect(entities.first.id, 1);
      });
      verify(mockClient.getCoinMarkets(start: 1, limit: 20));
    });

    test('should return Failure when call to client fails', () async {
      // Arrange
      when(
        mockClient.getCoinMarkets(
          start: anyNamed('start'),
          limit: anyNamed('limit'),
          convert: anyNamed('convert'),
          sort: anyNamed('sort'),
          sortDir: anyNamed('sortDir'),
        ),
      ).thenThrow(Exception());

      // Act
      final result = await dataSource.getCoinMarkets();

      // Assert
      expect(result.isLeft(), true);
    });
  });

  group('getCoinInfo', () {
    test('should return Map<String, CoinMarketEntity> when successful', () async {
      // Arrange
      final tMap = <String, CoinMarketModel>{'BTC': tCoinMarketModel};
      when(mockClient.getCoinInfo(symbol: 'BTC')).thenAnswer((_) async => tMap);

      // Act
      final result = await dataSource.getCoinInfo(symbol: 'BTC');

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Expected success'), (map) {
        expect(map['BTC']?.id, 1);
      });
    });
  });

  group('getCoinPriceConversion', () {
    test('should return CoinMarketEntity when successful', () async {
      // Arrange
      when(
        mockClient.getCoinPriceConversion(
          symbol: anyNamed('symbol'),
          amount: anyNamed('amount'),
          convert: anyNamed('convert'),
        ),
      ).thenAnswer((_) async => tCoinMarketModel);

      // Act
      final result = await dataSource.getCoinPriceConversion(
        symbol: 'BTC',
        amount: 1.0,
        convert: 'USD',
      );

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Expected success'), (entity) {
        expect(entity.id, 1);
      });
    });
  });

  group('getMaps', () {
    test('should return list of CoinMarketEntity when successful', () async {
      // Arrange
      when(mockClient.getMaps()).thenAnswer((_) async => tCoinMarketList);

      // Act
      final result = await dataSource.getMaps();

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Expected success'), (entities) {
        expect(entities.length, 1);
      });
    });
  });

  group('getOhlcv', () {
    test('should return Map<String, CoinMarketOhlcvEntity> when successful', () async {
      // Arrange
      final tMap = <String, CoinMarketOhlcvModel>{'BTC': tOhlcvModel};
      when(mockClient.getOhlcv(symbol: 'BTC', interval: '1d')).thenAnswer((_) async => tMap);

      // Act
      final result = await dataSource.getOhlcv(symbol: 'BTC', interval: '1d');

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Expected success'), (map) {
        expect(map['BTC']?.close, 105.0);
      });
    });
  });

  group('getGlobalMetrics', () {
    test('should return list of CoinMarketEntity when successful', () async {
      // Arrange
      when(mockClient.getGlobalMetrics()).thenAnswer((_) async => tCoinMarketList);

      // Act
      final result = await dataSource.getGlobalMetrics();

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Expected success'), (entities) {
        expect(entities.length, 1);
      });
    });
  });
}
