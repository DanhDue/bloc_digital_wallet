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

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late BootstrapUseCase useCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = BootstrapUseCase(mockRepository);
  });

  group('BootstrapUseCase', () {
    test('should return response on success', () async {
      // Arrange
      final response = SyncBootstrapResponse(
        userPreferences: const BootstrapUserPreferences(selectedLanguage: 'en'),
        translations: [],
        availableLanguages: [],
      );

      final request = const SyncBootstrapRequest(cachedTranslations: []);
      when(mockRepository.getAllCachedLanguageCodes()).thenAnswer((_) async => const Right([]));

      when(mockRepository.bootstrap(request)).thenAnswer((_) async => Right(response));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isRight(), true);
      verify(mockRepository.getAllCachedLanguageCodes()).called(1);
      verify(mockRepository.bootstrap(request)).called(1);
    });
  });
}
