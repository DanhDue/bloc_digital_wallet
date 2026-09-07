// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:settings/data/datasources/local/settings_local_datasource.dart';
import 'package:settings/data/datasources/remote/settings_remote_datasource.dart';
import 'package:settings/data/models/sync/available_language.dart';
import 'package:settings/data/models/sync/sync_bootstrap_request.dart';
import 'package:settings/data/models/sync/sync_bootstrap_response.dart';
import 'package:settings/data/models/sync/translation_override_response.dart';
import 'package:settings/data/repositories/settings_repository_impl.dart';
import 'package:settings/domain/entities/settings_entity.dart';

class MockSettingsRemoteDataSource extends Mock implements SettingsRemoteDataSource {}

class MockSettingsLocalDataSource extends Mock implements SettingsLocalDataSource {}

/// ### BDD SCENARIOS
///
/// Feature: Settings Data Layer & API Integration
///   As the settings data layer repository
///   I want robust remote API communication and dual-layer local caching
///   So that user preferences and translations are preserved across restarts and network outages
///
/// Scenario 1: getSettings delegates to remoteDataSource and returns entity on success
///   Given a functional remoteDataSource
///   When getSettings is invoked
///   Then it delegates to remoteDataSource and returns Right(SettingsEntity)
///
/// Scenario 2: bootstrap delegates to remoteDataSource and returns response on success
///   Given a valid bootstrap request
///   When bootstrap is invoked
///   Then it delegates to remoteDataSource and returns Right(SyncBootstrapResponse)
///
/// Scenario 3: getLocalizationOverrides delegates to remoteDataSource
///   Given a language code and optional sinceVersion
///   When getLocalizationOverrides is invoked
///   Then it delegates to remoteDataSource with corresponding arguments
///
/// Scenario 4: Caching operations succeed and return Right(null)
///   Given valid translation data and localDataSource
///   When saveCachedTranslationJson is invoked
///   Then it delegates to localDataSource and completes with Right(null)
///
/// Scenario 5: Caching operations catch exceptions and map to Left(CacheFailure)
///   Given a failing localDataSource throwing an exception
///   When saveCachedTranslationJson is invoked
///   Then it catches the exception and returns Left(CacheFailure)
///
/// Scenario 6: Retrieving cached language codes delegates to localDataSource
///   Given cached codes in localDataSource
///   When getAllCachedLanguageCodes is invoked
///   Then it returns `Right(List<String>)`
///
/// Scenario 7: Loading bundled fallback delegates and handles exceptions
///   Given a bundled fallback lookup
///   When localDataSource throws an exception
///   Then loadBundledFallback returns Left(CacheFailure)
void main() {
  late MockSettingsRemoteDataSource mockRemoteDataSource;
  late MockSettingsLocalDataSource mockLocalDataSource;
  late SettingsRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const SyncBootstrapRequest(cachedTranslations: []));
  });

  setUp(() {
    mockRemoteDataSource = MockSettingsRemoteDataSource();
    mockLocalDataSource = MockSettingsLocalDataSource();
    repository = SettingsRepositoryImpl(mockRemoteDataSource, mockLocalDataSource);
  });

  group('SettingsRepositoryImpl BDD / TDD Scenarios', () {
    test('Scenario 1: getSettings delegates to remoteDataSource', () async {
      const mockSettings = SettingsEntity(id: '1');
      when(
        () => mockRemoteDataSource.getSettings(),
      ).thenAnswer((_) async => const Right(mockSettings));

      final result = await repository.getSettings();

      expect(result, const Right(mockSettings));
      verify(() => mockRemoteDataSource.getSettings()).called(1);
    });

    test('Scenario 2: bootstrap delegates to remoteDataSource', () async {
      const request = SyncBootstrapRequest(cachedTranslations: []);
      const response = SyncBootstrapResponse(availableLanguages: []);
      when(
        () => mockRemoteDataSource.bootstrap(any()),
      ).thenAnswer((_) async => const Right(response));

      final result = await repository.bootstrap(request);

      expect(result, const Right(response));
      verify(() => mockRemoteDataSource.bootstrap(request)).called(1);
    });

    test('Scenario 3: getLocalizationOverrides delegates to remoteDataSource', () async {
      const overrideData = TranslationOverrideData(
        version: '1.0.0',
        translations: {'greeting': 'こんにちは'},
      );
      when(
        () => mockRemoteDataSource.getLocalizationOverrides(
          'ja',
          sinceVersion: '0.9.0',
          eTag: 'etag1',
        ),
      ).thenAnswer((_) async => const Right(overrideData));

      final result = await repository.getLocalizationOverrides(
        'ja',
        sinceVersion: '0.9.0',
        eTag: 'etag1',
      );

      expect(result, const Right(overrideData));
      verify(
        () => mockRemoteDataSource.getLocalizationOverrides(
          'ja',
          sinceVersion: '0.9.0',
          eTag: 'etag1',
        ),
      ).called(1);
    });

    test('Scenario 4: saveCachedTranslationJson delegates to localDataSource', () async {
      when(
        () => mockLocalDataSource.saveCachedTranslationJson('vi', {'key': 'value'}),
      ).thenAnswer((_) async {});

      final result = await repository.saveCachedTranslationJson('vi', {'key': 'value'});

      expect(result, const Right(null));
      verify(
        () => mockLocalDataSource.saveCachedTranslationJson('vi', {'key': 'value'}),
      ).called(1);
    });

    test(
      'Scenario 5: saveCachedTranslationJson catches exceptions and returns Left(CacheFailure)',
      () async {
        when(
          () => mockLocalDataSource.saveCachedTranslationJson('vi', any()),
        ).thenThrow(Exception('Disk full'));

        final result = await repository.saveCachedTranslationJson('vi', {'key': 'value'});

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<CacheFailure>()),
          (_) => fail('Expected Left(CacheFailure)'),
        );
      },
    );

    test('Scenario 6: getAllCachedLanguageCodes delegates to localDataSource', () async {
      when(
        () => mockLocalDataSource.getAllCachedLanguageCodes(),
      ).thenAnswer((_) async => ['en', 'vi', 'ja']);

      final result = await repository.getAllCachedLanguageCodes();

      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => []), equals(['en', 'vi', 'ja']));
      verify(() => mockLocalDataSource.getAllCachedLanguageCodes()).called(1);
    });

    test(
      'Scenario 7: getAvailableLanguages and saveAvailableLanguages delegate correctly',
      () async {
        const langs = <AvailableLanguage>[
          AvailableLanguage(languageCode: 'en', languageName: 'English', isDefault: true),
        ];
        when(() => mockLocalDataSource.saveAvailableLanguages(langs)).thenAnswer((_) async {});
        when(() => mockLocalDataSource.getAvailableLanguages()).thenAnswer((_) async => langs);

        final saveResult = await repository.saveAvailableLanguages(langs);
        final getResult = await repository.getAvailableLanguages();

        expect(saveResult, const Right(null));
        expect(getResult, const Right(langs));
        verify(() => mockLocalDataSource.saveAvailableLanguages(langs)).called(1);
        verify(() => mockLocalDataSource.getAvailableLanguages()).called(1);
      },
    );

    test(
      'Scenario 8: loadBundledFallback catches errors and returns Left(CacheFailure)',
      () async {
        when(
          () => mockLocalDataSource.loadBundledFallback('xx'),
        ).thenThrow(Exception('Asset not found'));

        final result = await repository.loadBundledFallback('xx');

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<CacheFailure>()),
          (_) => fail('Expected Left(CacheFailure)'),
        );
      },
    );
  });
}
