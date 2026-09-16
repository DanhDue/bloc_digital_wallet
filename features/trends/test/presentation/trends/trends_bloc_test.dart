// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trends/domain/entities/coin_market_entity.dart';
import 'package:trends/domain/usecases/get_coin_markets_usecase.dart';
import 'package:trends/presentation/trends/trends_bloc.dart';
import 'package:trends/presentation/trends/trends_event.dart';
import 'package:trends/presentation/trends/trends_state.dart';
import 'package:ui_kit/components/infinite_list/base_infinite_list_event.dart';
import 'package:ui_kit/components/infinite_list/base_infinite_list_state.dart';
import 'package:core/core.dart' hide test;

import 'trends_bloc_test.mocks.dart';

@GenerateMocks([GetCoinMarketsUseCase])
void main() {
  late TrendsBloc bloc;
  late MockGetCoinMarketsUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetCoinMarketsUseCase();
    bloc = TrendsBloc(mockUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  final tCoinMarketEntities = [
    const CoinMarketEntity(id: 1, name: 'Bitcoin', symbol: 'BTC', price: 50000),
    const CoinMarketEntity(id: 2, name: 'Ethereum', symbol: 'ETH', price: 3000),
  ];

  test('initial state should be initial', () {
    expect(bloc.state.status, InfiniteListStatus.initial);
  });

  blocTest<TrendsBloc, BaseInfiniteListState>(
    'emits [loading, success] when FetchFirstPage is added and usecase returns success',
    build: () {
      when(
        mockUseCase(page: anyNamed('page'), limit: anyNamed('limit')),
      ).thenAnswer((_) async => Right(tCoinMarketEntities));
      return bloc;
    },
    act: (bloc) => bloc.add(const InfiniteListFetchFirstPage()),
    expect: () => [
      isA<TrendsState>().having((s) => s.status, 'status', InfiniteListStatus.loading),
      isA<TrendsState>()
          .having((s) => s.status, 'status', InfiniteListStatus.success)
          .having((s) => s.items.length, 'items.length', 2),
    ],
    verify: (_) {
      verify(mockUseCase(page: 1, limit: 20));
    },
  );

  blocTest<TrendsBloc, BaseInfiniteListState>(
    'filters items when TrendsSearch event is added',
    build: () {
      when(
        mockUseCase(page: anyNamed('page'), limit: anyNamed('limit')),
      ).thenAnswer((_) async => Right(tCoinMarketEntities));
      return bloc;
    },
    act: (bloc) async {
      bloc.add(const InfiniteListFetchFirstPage());
      await Future.delayed(const Duration(milliseconds: 100));
      bloc.add(const TrendsSearch('BTC'));
    },
    skip: 2, // Skip loading and initial success states
    expect: () => [
      isA<TrendsState>()
          .having((s) => s.searchKeyword, 'searchKeyword', 'BTC')
          .having((s) => s.displayItems.length, 'displayItems.length', 1),
    ],
  );

  blocTest<TrendsBloc, BaseInfiniteListState>(
    'emits failure when usecase returns failure',
    build: () {
      when(
        mockUseCase(page: anyNamed('page'), limit: anyNamed('limit')),
      ).thenAnswer((_) async => Left(const UnknownFailure(message: 'Error')));
      return bloc;
    },
    act: (bloc) => bloc.add(const InfiniteListFetchFirstPage()),
    expect: () => [
      isA<TrendsState>().having((s) => s.status, 'status', InfiniteListStatus.loading),
      isA<TrendsState>()
          .having((s) => s.status, 'status', InfiniteListStatus.failure)
          .having((s) => s.errorMessage, 'errorMessage', contains('Error')),
    ],
  );

  blocTest<TrendsBloc, BaseInfiniteListState>(
    'updates search history when TrendsSearchSubmitted is added',
    build: () => bloc,
    act: (bloc) {
      bloc.add(const TrendsSearchSubmitted('BTC'));
      bloc.add(const TrendsSearchSubmitted('ETH'));
      bloc.add(const TrendsSearchSubmitted('BTC')); // Should move to top
    },
    expect: () => [
      isA<TrendsState>().having((s) => s.searchHistory, 'history', ['BTC']),
      isA<TrendsState>().having((s) => s.searchHistory, 'history', ['ETH', 'BTC']),
      isA<TrendsState>().having((s) => s.searchHistory, 'history', ['BTC', 'ETH']),
    ],
  );
}
