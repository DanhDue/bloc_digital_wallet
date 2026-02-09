// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trends/domain/entities/trends_entity.dart';
import 'package:trends/domain/usecases/get_trends_usecase.dart';
import 'package:trends/presentation/trends/trends_action.dart';
import 'package:trends/presentation/trends/trends_bloc.dart';
import 'package:trends/presentation/trends/trends_state.dart';
import 'package:core/core.dart' hide test;

import 'trends_bloc_test.mocks.dart';

@GenerateMocks([GetTrendsUseCase])
void main() {
  late TrendsBloc bloc;
  late MockGetTrendsUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetTrendsUseCase();
    bloc = TrendsBloc(mockUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  const tTrendsEntity = TrendsEntity(id: '1', name: 'Test', description: 'Description');

  test('initial state should be initial', () {
    expect(bloc.state.status, TrendsStatus.initial);
  });

  blocTest<TrendsBloc, TrendsState>(
    'emits [loading, success] when started is added and usecase returns success',
    build: () {
      when(mockUseCase()).thenAnswer((_) async => const Right(tTrendsEntity));
      return bloc;
    },
    act: (bloc) => bloc.add(const TrendsAction.started()),
    expect: () => [
      const TrendsState(status: TrendsStatus.loading),
      isA<TrendsState>()
          .having((s) => s.status, 'status', TrendsStatus.success)
          .having((s) => s.uiModel, 'uiModel', isNotNull),
    ],
    verify: (_) {
      verify(mockUseCase());
    },
  );
}
