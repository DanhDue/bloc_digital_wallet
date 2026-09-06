// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}_entity.dart';
import 'package:{{name.snakeCase()}}/domain/usecases/get_{{name.snakeCase()}}_usecase.dart';
import 'package:{{name.snakeCase()}}/presentation/{{name.snakeCase()}}/{{name.snakeCase()}}_action.dart';
import 'package:{{name.snakeCase()}}/presentation/{{name.snakeCase()}}/{{name.snakeCase()}}_bloc.dart';
import 'package:{{name.snakeCase()}}/presentation/{{name.snakeCase()}}/{{name.snakeCase()}}_state.dart';
import 'package:core/core.dart' hide test;

import '{{name.snakeCase()}}_bloc_test.mocks.dart';

@GenerateMocks([Get{{name.pascalCase()}}UseCase])
void main() {
  late {{name.pascalCase()}}Bloc bloc;
  late MockGet{{name.pascalCase()}}UseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGet{{name.pascalCase()}}UseCase();
    bloc = {{name.pascalCase()}}Bloc(mockUseCase);
  });

  const t{{name.pascalCase()}}Entity = {{name.pascalCase()}}Entity(
    id: '1',
    name: 'Test',
    description: 'Description',
  );

  test('initial state should be initial', () {
    expect(bloc.state.status, {{name.pascalCase()}}Status.initial);
  });

  blocTest<{{name.pascalCase()}}Bloc, {{name.pascalCase()}}State>(
    'emits [loading, success] when started is added and usecase returns success',
    build: () {
      when(mockUseCase()).thenAnswer((_) async => const Right(t{{name.pascalCase()}}Entity));
      return bloc;
    },
    act: (bloc) => bloc.add(const {{name.pascalCase()}}Action.started()),
    expect: () => [
      const {{name.pascalCase()}}State(status: {{name.pascalCase()}}Status.loading),
      isA<{{name.pascalCase()}}State>()
          .having((s) => s.status, 'status', {{name.pascalCase()}}Status.success)
          .having((s) => s.uiModel, 'uiModel', isNotNull),
    ],
    verify: (_) {
      verify(mockUseCase());
    },
  );
}
