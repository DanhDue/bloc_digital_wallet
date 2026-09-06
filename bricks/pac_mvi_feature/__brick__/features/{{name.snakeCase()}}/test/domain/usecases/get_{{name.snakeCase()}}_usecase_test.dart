// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}_entity.dart';
import 'package:{{name.snakeCase()}}/domain/repositories/{{name.snakeCase()}}_repository.dart';
import 'package:{{name.snakeCase()}}/domain/usecases/get_{{name.snakeCase()}}_usecase.dart';
import 'package:core/core.dart' hide test;

import 'get_{{name.snakeCase()}}_usecase_test.mocks.dart';

@GenerateMocks([{{name.pascalCase()}}Repository])
void main() {
  late Get{{name.pascalCase()}}UseCase useCase;
  late Mock{{name.pascalCase()}}Repository mockRepository;

  setUp(() {
    mockRepository = Mock{{name.pascalCase()}}Repository();
    useCase = Get{{name.pascalCase()}}UseCase(mockRepository);
  });

  const t{{name.pascalCase()}}Entity = {{name.pascalCase()}}Entity(
    id: '1',
    name: 'Test {{name.pascalCase()}}',
    description: 'Test Description',
  );

  test('should get {{name.camelCase()}} from the repository', () async {
    // arrange
    when(mockRepository.get{{name.pascalCase()}}())
        .thenAnswer((_) async => Right(t{{name.pascalCase()}}Entity));

    // act
    final result = await useCase();

    // assert
    expect(result, Right(t{{name.pascalCase()}}Entity));
    verify(mockRepository.get{{name.pascalCase()}}());
    verifyNoMoreInteractions(mockRepository);
  });
}
