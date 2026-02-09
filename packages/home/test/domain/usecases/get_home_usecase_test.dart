// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:home/domain/entities/home_entity.dart';
import 'package:home/domain/repositories/home_repository.dart';
import 'package:home/domain/usecases/get_home_usecase.dart';
import 'package:core/core.dart' hide test;

import 'get_home_usecase_test.mocks.dart';

@GenerateMocks([HomeRepository])
void main() {
  late GetHomeUseCase useCase;
  late MockHomeRepository mockRepository;

  setUp(() {
    mockRepository = MockHomeRepository();
    useCase = GetHomeUseCase(mockRepository);
  });

  const tHomeEntity = HomeEntity(id: '1', name: 'Test Home', description: 'Test Description');

  test('should get home from the repository', () async {
    // arrange
    when(mockRepository.getHome()).thenAnswer((_) async => Right(tHomeEntity));

    // act
    final result = await useCase();

    // assert
    expect(result, Right(tHomeEntity));
    verify(mockRepository.getHome());
    verifyNoMoreInteractions(mockRepository);
  });
}
