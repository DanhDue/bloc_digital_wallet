// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:settings/data/models/sync/bootstrap_translation_item.dart';
import 'package:settings/domain/usecases/fetch_translation_usecase.dart';

import 'get_settings_usecase_test.mocks.dart';

void main() {
  late FetchTranslationUseCase useCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = FetchTranslationUseCase(mockRepository);

    // Reset singleton if it was modified
    // LocalizationManager.instance is a singleton, we assume it doesn't crash during applyDynamicTranslations in test
    if (!GetIt.instance.isRegistered<Talker>()) {
      final talker = Talker();
      GetIt.instance.registerSingleton<Talker>(talker);
      Log.init(talker);
    }
  });

  group('FetchTranslationUseCase HTTP Caching (304)', () {
    test('should return Right(null) when server returns 304 Not Modified', () async {
      // Arrange
      const languageCode = 'en';
      final item = BootstrapTranslationItem(
        resourceId: languageCode,
        mode: 'delta',
        latestVersion: '1.0.1',
      );
      final cachedJson = {'hello': 'world'};
      final expectedChecksum = ChecksumUtils.computeSha256(cachedJson);

      when(
        mockRepository.getCachedTranslationVersion(languageCode),
      ).thenAnswer((_) async => Right<Failure, String?>('1.0.0'));

      when(
        mockRepository.getCachedTranslationJson(languageCode),
      ).thenAnswer((_) async => Right<Failure, Map<String, dynamic>?>(cachedJson));

      // Simulate a 304 ServerFailure
      when(
        mockRepository.getLocalizationOverrides(
          languageCode,
          sinceVersion: '1.0.0',
          eTag: '"$expectedChecksum"',
        ),
      ).thenAnswer((_) async => const Left(ServerFailure(message: 'Not Modified', code: 304)));

      // Act
      final result = await useCase(item);

      // Assert
      expect(result.isRight(), true);

      // Verify that no saving happened because it was 304
      verifyNever(mockRepository.saveCachedTranslationJson(languageCode, any));
      verifyNever(mockRepository.saveCachedTranslationVersion(languageCode, any));
    });
  });
}
