// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:settings/domain/entities/settings_entity.dart';
import 'package:settings/domain/repositories/settings_repository.dart';
import 'package:settings/domain/usecases/get_settings_usecase.dart';
import 'package:core/core.dart' hide test;

import 'get_settings_usecase_test.mocks.dart';

@GenerateMocks([SettingsRepository])
void main() {
  late GetSettingsUseCase useCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = GetSettingsUseCase(mockRepository);
  });

  const tSettingsEntity = SettingsEntity(
    id: '1',
    userName: 'Test User',
    email: 'test@example.com',
    isDarkModeEnabled: true,
    isBiometricEnabled: false,
    selectedCurrency: 'USD',
    isNotificationsEnabled: true,
    isDeveloperModeEnabled: false,
  );

  test('should get settings from the repository', () async {
    // arrange
    when(mockRepository.getSettings()).thenAnswer((_) async => Right(tSettingsEntity));

    // act
    final result = await useCase();

    // assert
    expect(result, Right(tSettingsEntity));
    verify(mockRepository.getSettings());
    verifyNoMoreInteractions(mockRepository);
  });
}
