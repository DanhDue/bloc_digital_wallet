// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart' hide test;
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:settings/domain/repositories/settings_repository.dart';
import 'package:settings/domain/usecases/check_language_cached_usecase.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late CheckLanguageCachedUseCase usecase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    usecase = CheckLanguageCachedUseCase(mockRepository);
  });

  group('CheckLanguageCachedUseCase', () {
    test(
      'Scenario 1: Returns true immediately for bundled languages with or without region tags',
      () async {
        final bundledCodes = [
          'en',
          'vi',
          'en_US',
          'en-US',
          'vi_VN',
          'vi-VN',
          'en_GB',
        ];

        for (final code in bundledCodes) {
          final result = await usecase(code);
          expect(
            result,
            isTrue,
            reason:
                'Expected $code to be recognized as cached bundled language',
          );
          verifyZeroInteractions(mockRepository);
        }
      },
    );

    test(
      'Scenario 2: Checks repository for remote OTA languages and returns true if version exists',
      () async {
        when(
          () => mockRepository.getCachedTranslationVersion('ja'),
        ).thenAnswer((_) async => const Right('1.0.0'));

        final result = await usecase('ja');

        expect(result, isTrue);
        verify(
          () => mockRepository.getCachedTranslationVersion('ja'),
        ).called(1);
      },
    );

    test(
      'Scenario 3: Checks repository for remote OTA languages and returns false if version is null or failure',
      () async {
        when(
          () => mockRepository.getCachedTranslationVersion('ko'),
        ).thenAnswer((_) async => const Right(null));

        final result = await usecase('ko');

        expect(result, isFalse);
        verify(
          () => mockRepository.getCachedTranslationVersion('ko'),
        ).called(1);
      },
    );
  });
}
