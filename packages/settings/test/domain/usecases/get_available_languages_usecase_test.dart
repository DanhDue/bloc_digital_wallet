// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:core/core.dart' hide test;
import 'package:settings/data/models/sync/available_language.dart';
import 'package:settings/domain/repositories/settings_repository.dart';
import 'package:settings/domain/usecases/get_available_languages_usecase.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {
  @override
  Future<Either<Failure, List<AvailableLanguage>>> getAvailableLanguages() async {
    return super.noSuchMethod(
      Invocation.method(#getAvailableLanguages, []),
      returnValue: Future.value(Right<Failure, List<AvailableLanguage>>(<AvailableLanguage>[])),
    );
  }
}

void main() {
  late GetAvailableLanguagesUseCase useCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = GetAvailableLanguagesUseCase(mockRepository);
  });

  group('GetAvailableLanguagesUseCase', () {
    test('should return list of available languages from repository', () async {
      // Arrange
      final languages = [
        const AvailableLanguage(
          languageCode: 'en',
          languageName: 'English',
          isDefault: true,
          isActive: true,
        ),
      ];
      when(
        mockRepository.getAvailableLanguages(),
      ).thenAnswer((_) async => Right<Failure, List<AvailableLanguage>>(languages));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), equals(languages));
      verify(mockRepository.getAvailableLanguages()).called(1);
    });
  });
}
