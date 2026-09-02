// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart' hide test;
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:settings/domain/usecases/change_language_usecase.dart';
import 'package:settings/domain/usecases/check_language_cached_usecase.dart';
import 'package:settings/domain/usecases/get_dynamic_localization_usecase.dart';
import 'package:settings/domain/usecases/update_user_language_usecase.dart';

class MockCheckLanguageCachedUseCase extends Mock implements CheckLanguageCachedUseCase {}

class MockGetDynamicLocalizationUseCase extends Mock implements GetDynamicLocalizationUseCase {}

class MockUpdateUserLanguageUseCase extends Mock implements UpdateUserLanguageUseCase {}

void main() {
  late ChangeLanguageUseCase usecase;
  late MockCheckLanguageCachedUseCase mockCheckLanguageCachedUseCase;
  late MockGetDynamicLocalizationUseCase mockGetDynamicLocalizationUseCase;
  late MockUpdateUserLanguageUseCase mockUpdateUserLanguageUseCase;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    D3NexusLogger.initialize(LogManagerImpl());

    mockCheckLanguageCachedUseCase = MockCheckLanguageCachedUseCase();
    mockGetDynamicLocalizationUseCase = MockGetDynamicLocalizationUseCase();
    mockUpdateUserLanguageUseCase = MockUpdateUserLanguageUseCase();

    usecase = ChangeLanguageUseCase(
      mockCheckLanguageCachedUseCase,
      mockGetDynamicLocalizationUseCase,
      mockUpdateUserLanguageUseCase,
    );

    // Initialize slang to a default locale for testing
    LocaleSettings.useDeviceLocale();
    await LocalizationManager.instance.setLocaleFromCode('en');
  });

  group('ChangeLanguageUseCase', () {
    test(
      'Scenario 1: Happy Path - Switching to a new language (Cached)',
      () async {
        // Arrange
        when(() => mockCheckLanguageCachedUseCase('ja')).thenAnswer((_) async => true);
        when(
          () => mockGetDynamicLocalizationUseCase('ja'),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockUpdateUserLanguageUseCase('ja'),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final stream = usecase('ja');

        // Assert
        await expectLater(
          stream,
          emitsInOrder([
            LanguageSyncStatus.cachedApplied, // Optimistic UI
            LanguageSyncStatus.success, // After API and backend update
            emitsDone,
          ]),
        );
      },
    );

    test(
      'Scenario 2: Happy Path - Switching to a new language (Not Cached)',
      () async {
        // Arrange
        when(() => mockCheckLanguageCachedUseCase('vi')).thenAnswer((_) async => false);
        when(
          () => mockGetDynamicLocalizationUseCase('vi'),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockUpdateUserLanguageUseCase('vi'),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final stream = usecase('vi');

        // Assert
        await expectLater(
          stream,
          emitsInOrder([
            LanguageSyncStatus.loading, // Needs to show loader
            LanguageSyncStatus.success, // After API and backend update
            emitsDone,
          ]),
        );
      },
    );

    test(
      'Scenario 3: Edge Case - Switching to the SAME language',
      () async {
        // Arrange
        // Already 'en' because of setUp
        when(
          () => mockGetDynamicLocalizationUseCase('en'),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final stream = usecase('en');

        // Assert
        await expectLater(
          stream,
          emitsInOrder([
            // Should NOT emit any UI states (no loading, no cachedApplied, no success)
            // It silently calls GetDynamicLocalizationUseCase
            emitsDone,
          ]),
        );

        // Verify setLocaleFromCode and UpdateUserLanguageUseCase were skipped
        verifyNever(() => mockUpdateUserLanguageUseCase(any()));
        // GetDynamicLocalizationUseCase MUST be called to check for delta
        verify(() => mockGetDynamicLocalizationUseCase('en')).called(1);
      },
    );

    test(
      'ChangeLanguageUseCase Scenario 4: Edge Case - Switching to the SAME language (Network Failure)',
      () async {
        // Arrange
        await LocalizationManager.instance.setLocaleFromCode('en');
        final usecase = ChangeLanguageUseCase(
          mockCheckLanguageCachedUseCase,
          mockGetDynamicLocalizationUseCase,
          mockUpdateUserLanguageUseCase,
        );

        when(
          () => mockGetDynamicLocalizationUseCase('en'),
        ).thenAnswer((_) async => const Left(ServerFailure(message: 'Network Error')));

        // Act
        final stream = usecase('en');

        // Assert
        await expectLater(
          stream,
          emitsInOrder([
            LanguageSyncStatus.error,
            emitsDone,
          ]),
        );

        // Verify setLocaleFromCode and UpdateUserLanguageUseCase were skipped
        verifyNever(() => mockUpdateUserLanguageUseCase(any()));
        verify(() => mockGetDynamicLocalizationUseCase('en')).called(1);
      },
    );

    test(
      'ChangeLanguageUseCase Scenario 5: Network Failure - Switching to a new language (Not Cached) fails',
      () async {
        // Arrange
        when(() => mockCheckLanguageCachedUseCase('vi')).thenAnswer((_) async => false);
        when(
          () => mockGetDynamicLocalizationUseCase('vi'),
        ).thenAnswer((_) async => const Left(ServerFailure(message: 'Network Error', code: 500)));
        when(
          () => mockUpdateUserLanguageUseCase('vi'),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final stream = usecase('vi');

        // Assert
        await expectLater(
          stream,
          emitsInOrder([
            LanguageSyncStatus.loading,
            LanguageSyncStatus.error,
            emitsDone,
          ]),
        );
      },
    );

    test(
      'Scenario 6: Network Failure - Switching to a new language (Cached) fails',
      () async {
        // Arrange
        when(() => mockCheckLanguageCachedUseCase('ja')).thenAnswer((_) async => true);
        when(
          () => mockGetDynamicLocalizationUseCase('ja'),
        ).thenAnswer((_) async => const Left(ServerFailure(message: 'Network Error', code: 500)));
        when(
          () => mockUpdateUserLanguageUseCase('ja'),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final stream = usecase('ja');

        // Assert
        await expectLater(
          stream,
          emitsInOrder([
            LanguageSyncStatus.cachedApplied, // Optimistic UI still happens
            LanguageSyncStatus.error, // But network fails
            emitsDone,
          ]),
        );

        // Verify UpdateUserLanguageUseCase was called
        verify(() => mockUpdateUserLanguageUseCase('ja')).called(1);
      },
    );
  });
}
