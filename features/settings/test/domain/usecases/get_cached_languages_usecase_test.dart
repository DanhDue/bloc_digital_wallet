// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart' hide test;
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:settings/data/models/sync/available_language.dart';
import 'package:settings/domain/repositories/settings_repository.dart';
import 'package:settings/domain/usecases/check_language_cached_usecase.dart';
import 'package:settings/domain/usecases/get_cached_languages_usecase.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockCheckLanguageCachedUseCase extends Mock implements CheckLanguageCachedUseCase {}

void main() {
  late GetCachedLanguagesUseCase useCase;
  late MockSettingsRepository mockRepository;
  late MockCheckLanguageCachedUseCase mockCheckLanguageCachedUseCase;

  setUp(() {
    mockRepository = MockSettingsRepository();
    mockCheckLanguageCachedUseCase = MockCheckLanguageCachedUseCase();
    useCase = GetCachedLanguagesUseCase(mockRepository, mockCheckLanguageCachedUseCase);
  });

  group('GetCachedLanguagesUseCase', () {
    test('returns bundled default languages (en, vi) when stored cache is empty', () async {
      when(() => mockRepository.getAvailableLanguages()).thenAnswer((_) async => const Right([]));

      final result = await useCase();

      expect(result.isRight(), isTrue);
      final languages = result.getOrElse(() => []);
      expect(languages.length, equals(2));
      expect(languages[0].languageCode, equals('en'));
      expect(languages[0].languageName, equals('English'));
      expect(languages[0].isDefault, isTrue);
      expect(languages[0].isCached, isTrue);
      expect(languages[1].languageCode, equals('vi'));
      expect(languages[1].languageName, equals('Tiếng Việt'));
      expect(languages[1].isDefault, isFalse);
      expect(languages[1].isCached, isTrue);
    });

    test('returns bundled default languages when repository returns failure', () async {
      when(
        () => mockRepository.getAvailableLanguages(),
      ).thenAnswer((_) async => const Left(CacheFailure(message: 'Cache miss')));

      final result = await useCase();

      expect(result.isRight(), isTrue);
      final languages = result.getOrElse(() => []);
      expect(languages.length, equals(2));
      expect(languages.map((e) => e.languageCode), containsAll(['en', 'vi']));
      expect(languages.every((l) => l.isCached), isTrue);
    });

    test('maps available languages and checks cache status for remote languages', () async {
      when(() => mockRepository.getAvailableLanguages()).thenAnswer(
        (_) async => const Right([
          AvailableLanguage(languageCode: 'en', languageName: 'English', isDefault: true),
          AvailableLanguage(languageCode: 'vi', languageName: 'Tiếng Việt', isDefault: false),
          AvailableLanguage(languageCode: 'ja', languageName: 'Japanese', isDefault: false),
        ]),
      );
      when(() => mockCheckLanguageCachedUseCase('en')).thenAnswer((_) async => true);
      when(() => mockCheckLanguageCachedUseCase('vi')).thenAnswer((_) async => true);
      when(() => mockCheckLanguageCachedUseCase('ja')).thenAnswer((_) async => false);

      final result = await useCase();

      expect(result.isRight(), isTrue);
      final languages = result.getOrElse(() => []);
      expect(languages.length, equals(3));
      expect(languages.firstWhere((l) => l.languageCode == 'en').isCached, isTrue);
      expect(languages.firstWhere((l) => l.languageCode == 'vi').isCached, isTrue);
      expect(languages.firstWhere((l) => l.languageCode == 'ja').isCached, isFalse);
    });
  });
}
