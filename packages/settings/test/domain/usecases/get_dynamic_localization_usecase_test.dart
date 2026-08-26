// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';
import 'package:mockito/mockito.dart';
import 'package:settings/domain/usecases/get_dynamic_localization_usecase.dart';

import 'get_settings_usecase_test.mocks.dart';

void main() {
  late GetDynamicLocalizationUseCase useCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = GetDynamicLocalizationUseCase(mockRepository);
    if (!GetIt.instance.isRegistered<Talker>()) {
      final talker = Talker();
      GetIt.instance.registerSingleton<Talker>(talker);
    }

    // LocalizationManager.applyDynamicTranslations (exercised via
    // GetDynamicLocalizationUseCase) logs through D3NexusLogger; wire it to
    // a no-op manager (no appenders registered) so the static facade isn't
    // left uninitialized in this test isolate.
    D3NexusLogger.initialize(LogManagerImpl());
  });

  group('GetDynamicLocalizationUseCase HTTP Caching (304)', () {
    test(
      'should apply translations from local cache and return Right(null) when server returns 304',
      () async {
        // Arrange
        const languageCode = 'en';
        final cachedJson = {'title': 'Hello'};
        final expectedChecksum = ChecksumUtils.computeSha256(cachedJson);

        when(
          mockRepository.getCachedTranslationVersion(languageCode),
        ).thenAnswer((_) async => Right<Failure, String?>('1.0.2'));

        when(
          mockRepository.getCachedTranslationJson(languageCode),
        ).thenAnswer((_) async => Right<Failure, Map<String, dynamic>?>(cachedJson));

        // Simulate a 304 ServerFailure
        when(
          mockRepository.getLocalizationOverrides(
            languageCode,
            sinceVersion: '1.0.2',
            eTag: '"$expectedChecksum"',
          ),
        ).thenAnswer((_) async => const Left(ServerFailure(message: 'Not Modified', code: 304)));

        // Act
        final result = await useCase(languageCode);

        // Assert
        expect(result.isRight(), true);

        // Because it returned 304, it shouldn't save new translations to cache
        verifyNever(mockRepository.saveCachedTranslationJson(languageCode, any));
        verifyNever(mockRepository.saveCachedTranslationVersion(languageCode, any));
      },
    );
  });
}
