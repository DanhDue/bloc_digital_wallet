// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:home/domain/entities/home_entity.dart';
import 'package:home/domain/usecases/get_home_usecase.dart';
import 'package:home/presentation/home/home_action.dart';
import 'package:home/presentation/home/home_bloc.dart';
import 'package:home/presentation/home/home_state.dart';
import 'package:core/core.dart' hide test;

import 'home_bloc_test.mocks.dart';

@GenerateMocks([GetHomeUseCase])
void main() {
  late HomeBloc bloc;
  late MockGetHomeUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetHomeUseCase();
    bloc = HomeBloc(mockUseCase);
  });

  const tHomeEntity = HomeEntity(id: '1', name: 'Test', description: 'Description');

  test('initial state should be initial', () {
    expect(bloc.state.status, HomeStatus.initial);
  });

  blocTest<HomeBloc, HomeState>(
    'emits [loading, success] when started is added and usecase returns success',
    build: () {
      when(mockUseCase()).thenAnswer((_) async => const Right(tHomeEntity));
      return bloc;
    },
    act: (bloc) => bloc.add(const HomeAction.started()),
    expect: () => [
      const HomeState(status: HomeStatus.loading),
      isA<HomeState>()
          .having((s) => s.status, 'status', HomeStatus.success)
          .having((s) => s.uiModel, 'uiModel', isNotNull),
    ],
    verify: (_) {
      verify(mockUseCase());
    },
  );
}
