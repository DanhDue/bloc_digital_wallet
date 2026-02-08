// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trends/domain/entities/trends_entity.dart';
import 'package:trends/domain/repositories/trends_repository.dart';
import 'package:trends/domain/usecases/get_trends_usecase.dart';
import 'package:core/core.dart' hide test;

import 'get_trends_usecase_test.mocks.dart';

@GenerateMocks([TrendsRepository])
void main() {
  late GetTrendsUseCase useCase;
  late MockTrendsRepository mockRepository;

  setUp(() {
    mockRepository = MockTrendsRepository();
    useCase = GetTrendsUseCase(mockRepository);
  });

  const tTrendsEntity = TrendsEntity(
    id: '1',
    name: 'Test Trends',
    description: 'Test Description',
  );

  test('should get trends from the repository', () async {
    // arrange
    when(mockRepository.getTrends()).thenAnswer((_) async => Right(tTrendsEntity));

    // act
    final result = await useCase();

    // assert
    expect(result, Right(tTrendsEntity));
    verify(mockRepository.getTrends());
    verifyNoMoreInteractions(mockRepository);
  });
}
