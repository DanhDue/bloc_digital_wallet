// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:settings/domain/repositories/settings_repository.dart';
import 'package:settings/domain/usecases/bootstrap_usecase.dart';
import 'package:settings/data/models/sync/sync_bootstrap_response.dart';
import 'package:settings/data/models/sync/bootstrap_user_preferences.dart';
import 'package:settings/data/models/sync/sync_bootstrap_request.dart';
import 'package:settings/data/models/sync/available_language.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {
  @override
  Future<Either<Failure, List<String>>> getAllCachedLanguageCodes() async {
    return super.noSuchMethod(
      Invocation.method(#getAllCachedLanguageCodes, []),
      returnValue: Future.value(Right<Failure, List<String>>(<String>[])),
    );
  }

  @override
  Future<Either<Failure, void>> saveAvailableLanguages(List<AvailableLanguage> languages) async {
    return super.noSuchMethod(
      Invocation.method(#saveAvailableLanguages, [languages]),
      returnValue: Future.value(Right<Failure, void>(null)),
    );
  }

  @override
  Future<Either<Failure, SyncBootstrapResponse>> bootstrap(SyncBootstrapRequest request) async {
    return super.noSuchMethod(
      Invocation.method(#bootstrap, [request]),
      returnValue: Future.value(
        Right<Failure, SyncBootstrapResponse>(
          const SyncBootstrapResponse(translations: [], availableLanguages: []),
        ),
      ),
    );
  }
}

void main() {
  late BootstrapUseCase useCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = BootstrapUseCase(mockRepository);
  });

  group('BootstrapUseCase', () {
    test(
      'should merge BE languages with default languages and save (BE returns only 1)',
      () async {
        // Arrange
        // BE returns only English with some updated property, say isActive: false
        final List<AvailableLanguage> beLanguages = [
          AvailableLanguage(
            languageCode: 'en',
            languageName: 'English (Updated)',
            isDefault: true,
            isActive: false,
          ),
        ];
        final response = SyncBootstrapResponse(
          userPreferences: const BootstrapUserPreferences(selectedLanguage: 'en'),
          translations: [],
          availableLanguages: beLanguages,
        );

        final request = const SyncBootstrapRequest(cachedTranslations: []);
        when(
          mockRepository.getAllCachedLanguageCodes(),
        ).thenAnswer((_) async => Right<Failure, List<String>>(<String>[]));

        final expectedMergedLanguages = [
          AvailableLanguage(
            languageCode: 'en',
            languageName: 'English (Updated)',
            isDefault: true,
            isActive: false,
          ),
          AvailableLanguage(
            languageCode: 'vi',
            languageName: 'Tiếng Việt',
            isDefault: false,
            isActive: true,
          ),
        ];

        when(
          mockRepository.saveAvailableLanguages(expectedMergedLanguages),
        ).thenAnswer((_) async => Right<Failure, void>(null));
        when(
          mockRepository.bootstrap(request),
        ).thenAnswer((_) async => Right<Failure, SyncBootstrapResponse>(response));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        verify(mockRepository.bootstrap(request)).called(1);
        verify(mockRepository.saveAvailableLanguages(expectedMergedLanguages)).called(1);
      },
    );

    test('should append new language from BE to default languages and save', () async {
      // Arrange
      // BE returns Japanese which is new, and doesn't return default ones (empty or just one)
      final List<AvailableLanguage> beLanguages = [
        AvailableLanguage(
          languageCode: 'ja',
          languageName: 'Japanese',
          isDefault: false,
          isActive: true,
        ),
      ];
      final response = SyncBootstrapResponse(
        userPreferences: const BootstrapUserPreferences(selectedLanguage: 'ja'),
        translations: [],
        availableLanguages: beLanguages,
      );

      final request = const SyncBootstrapRequest(cachedTranslations: []);
      when(
        mockRepository.getAllCachedLanguageCodes(),
      ).thenAnswer((_) async => Right<Failure, List<String>>(<String>[]));

      final expectedMergedLanguages = [
        AvailableLanguage(
          languageCode: 'en',
          languageName: 'English',
          isDefault: true,
          isActive: true,
        ),
        AvailableLanguage(
          languageCode: 'vi',
          languageName: 'Tiếng Việt',
          isDefault: false,
          isActive: true,
        ),
        AvailableLanguage(
          languageCode: 'ja',
          languageName: 'Japanese',
          isDefault: false,
          isActive: true,
        ),
      ];

      when(
        mockRepository.saveAvailableLanguages(expectedMergedLanguages),
      ).thenAnswer((_) async => Right<Failure, void>(null));
      when(
        mockRepository.bootstrap(request),
      ).thenAnswer((_) async => Right<Failure, SyncBootstrapResponse>(response));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isRight(), true);
      verify(mockRepository.bootstrap(request)).called(1);
      verify(mockRepository.saveAvailableLanguages(expectedMergedLanguages)).called(1);
    });
  });
}
