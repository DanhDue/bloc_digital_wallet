// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:scanner/domain/entities/scanner_entity.dart';
import 'package:scanner/domain/repositories/scanner_repository.dart';
import 'package:scanner/domain/usecases/get_scanner_usecase.dart';
import 'package:core/core.dart' hide test;

import 'get_scanner_usecase_test.mocks.dart';

@GenerateMocks([ScannerRepository])
void main() {
  late GetScannerUseCase useCase;
  late MockScannerRepository mockRepository;

  setUp(() {
    mockRepository = MockScannerRepository();
    useCase = GetScannerUseCase(mockRepository);
  });

  const tScannerEntity = ScannerEntity(
    id: '1',
    name: 'Test Scanner',
    description: 'Test Description',
  );

  test('should get scanner from the repository', () async {
    // arrange
    when(mockRepository.getScanner()).thenAnswer((_) async => Right(tScannerEntity));

    // act
    final result = await useCase();

    // assert
    expect(result, Right(tScannerEntity));
    verify(mockRepository.getScanner());
    verifyNoMoreInteractions(mockRepository);
  });
}
