// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart' hide test;
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:settings/domain/entities/language_sync_status.dart';
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

    LocaleSettings.useDeviceLocale();
    await LocalizationManager.instance.setLocaleFromCode('en');
  });

  group('ChangeLanguageUseCase', () {
    test('Scenario 1: Same Language Selection - Skips silently without emissions', () async {
      final stream = usecase('en');

      await expectLater(stream, emitsDone);

      verifyNever(() => mockUpdateUserLanguageUseCase(any()));
      verifyNever(() => mockGetDynamicLocalizationUseCase(any()));
    });

    test('Scenario 2: Optimistic switch for bundled or cached language (vi)', () async {
      when(() => mockCheckLanguageCachedUseCase('vi')).thenAnswer((_) async => true);
      when(() => mockGetDynamicLocalizationUseCase('vi'))
          .thenAnswer((_) async => const Right(null));
      when(() => mockUpdateUserLanguageUseCase('vi'))
          .thenAnswer((_) async => const Right(null));

      final stream = usecase('vi');

      await expectLater(
        stream,
        emitsInOrder([
          const LanguageSyncStatus.cachedApplied('vi'),
          const LanguageSyncStatus.success('vi'),
          emitsDone,
        ]),
      );

      expect(LocalizationManager.instance.currentLocale.languageCode, equals('vi'));
      verify(() => mockUpdateUserLanguageUseCase('vi')).called(1);
    });

    test('Scenario 3: Uncached remote language (ja) shows loading dialog then succeeds', () async {
      when(() => mockCheckLanguageCachedUseCase('ja')).thenAnswer((_) async => false);
      when(() => mockGetDynamicLocalizationUseCase('ja'))
          .thenAnswer((_) async => const Right(null));
      when(() => mockUpdateUserLanguageUseCase('ja'))
          .thenAnswer((_) async => const Right(null));

      final stream = usecase('ja');

      await expectLater(
        stream,
        emitsInOrder([
          const LanguageSyncStatus.loading('ja'),
          const LanguageSyncStatus.success('ja'),
          emitsDone,
        ]),
      );

      expect(LocalizationManager.instance.currentLocale.languageCode, equals('ja'));
      verify(() => mockUpdateUserLanguageUseCase('ja')).called(1);
    });

    test('Scenario 4: Uncached remote language network failure rolls back and retains locale', () async {
      await LocalizationManager.instance.setLocaleFromCode('en');
      when(() => mockCheckLanguageCachedUseCase('ko')).thenAnswer((_) async => false);
      when(() => mockGetDynamicLocalizationUseCase('ko')).thenAnswer(
        (_) async => const Left(ServerFailure(message: 'Connection timeout', code: 504)),
      );
      when(() => mockUpdateUserLanguageUseCase('ko'))
          .thenAnswer((_) async => const Right(null));

      final stream = usecase('ko');

      await expectLater(
        stream,
        emitsInOrder([
          const LanguageSyncStatus.loading('ko'),
          const LanguageSyncStatus.error('ko', 'Connection timeout'),
          emitsDone,
        ]),
      );

      // Active locale must still be English
      expect(LocalizationManager.instance.currentLocale.languageCode, equals('en'));
    });
  });
}
