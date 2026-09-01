// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:settings/domain/entities/settings_entity.dart';
// import 'package:settings/domain/usecases/get_settings_usecase.dart';
import 'package:settings/domain/usecases/check_language_cached_usecase.dart';
import 'package:settings/data/models/sync/available_language.dart';
import 'package:settings/domain/usecases/get_available_languages_usecase.dart';
import 'package:settings/domain/usecases/update_user_language_usecase.dart';
import 'package:settings/domain/usecases/get_dynamic_localization_usecase.dart';
import 'package:settings/presentation/settings/settings_action.dart';
import 'package:settings/presentation/settings/settings_bloc.dart';
import 'package:settings/presentation/settings/settings_state.dart';
import 'package:core/core.dart' hide test;

import 'settings_bloc_test.mocks.dart';

@GenerateMocks([
  AppInfoService,
  UpdateUserLanguageUseCase,
  GetAvailableLanguagesUseCase,
  GetDynamicLocalizationUseCase,
  CheckLanguageCachedUseCase,
])
void main() {
  late SettingsBloc bloc;
  late MockAppInfoService mockAppInfoService;
  late MockUpdateUserLanguageUseCase mockUpdateUserLanguageUseCase;
  late MockGetAvailableLanguagesUseCase mockGetAvailableLanguagesUseCase;
  late MockGetDynamicLocalizationUseCase mockGetDynamicLocalizationUseCase;
  late MockCheckLanguageCachedUseCase mockCheckLanguageCachedUseCase;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    D3NexusLogger.initialize(LogManagerImpl());

    mockAppInfoService = MockAppInfoService();
    mockUpdateUserLanguageUseCase = MockUpdateUserLanguageUseCase();
    mockGetAvailableLanguagesUseCase = MockGetAvailableLanguagesUseCase();
    mockGetDynamicLocalizationUseCase = MockGetDynamicLocalizationUseCase();
    mockCheckLanguageCachedUseCase = MockCheckLanguageCachedUseCase();

    when(mockAppInfoService.getPackageInfo()).thenAnswer(
      (_) async => PackageInfo(
        appName: 'Insight',
        packageName: 'com.example.insight',
        version: '1.0.0',
        buildNumber: '1',
      ),
    );
    when(mockGetAvailableLanguagesUseCase()).thenAnswer((_) async => Right(<AvailableLanguage>[]));
    when(mockGetDynamicLocalizationUseCase(any)).thenAnswer((_) async => const Right(null));
    when(mockUpdateUserLanguageUseCase(any)).thenAnswer((_) async => const Right(null));
    when(mockCheckLanguageCachedUseCase(any)).thenAnswer((_) async => true);

    bloc = SettingsBloc(
      mockAppInfoService,
      mockUpdateUserLanguageUseCase,
      mockGetAvailableLanguagesUseCase,
      mockGetDynamicLocalizationUseCase,
      mockCheckLanguageCachedUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be initial', () {
    expect(bloc.state.status, SettingsStatus.initial);
  });

  blocTest<SettingsBloc, SettingsState>(
    'emits [loading, success] when started is added and usecase returns success',
    build: () => bloc,
    act: (bloc) => bloc.add(const SettingsAction.started()),
    expect: () => [
      const SettingsState(status: SettingsStatus.loading),
      isA<SettingsState>()
          .having((s) => s.status, 'status', SettingsStatus.success)
          .having((s) => s.uiModel?.appVersion, 'appVersion', '1.0.0'),
    ],
    verify: (_) {
      verify(mockAppInfoService.getPackageInfo()).called(1);
      verify(mockGetAvailableLanguagesUseCase()).called(1);
    },
  );

  group('changeLanguage', () {
    blocTest<SettingsBloc, SettingsState>(
      'switches the locale immediately when language is cached (optimistic update)',
      build: () {
        when(mockCheckLanguageCachedUseCase('ko')).thenAnswer((_) async => true);
        when(mockGetDynamicLocalizationUseCase('ko')).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Language content not available yet')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const SettingsAction.changeLanguage(languageCode: 'ko')),
      wait: const Duration(milliseconds: 10),
      verify: (_) {
        expect(LocalizationManager.instance.currentLocale.languageCode, 'ko');
        verify(mockUpdateUserLanguageUseCase('ko')).called(1);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'emits [loading, success] and delays UI switch when language is NOT cached',
      build: () {
        when(mockCheckLanguageCachedUseCase('ja')).thenAnswer((_) async => false);
        when(mockGetDynamicLocalizationUseCase('ja')).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(const SettingsAction.changeLanguage(languageCode: 'ja')),
      wait: const Duration(milliseconds: 10),
      expect: () => [
        const SettingsState(status: SettingsStatus.loading),
        const SettingsState(status: SettingsStatus.success),
      ],
      verify: (_) {
        expect(LocalizationManager.instance.currentLocale.languageCode, 'ja');
        verify(mockUpdateUserLanguageUseCase('ja')).called(1);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'ignores outdated language requests during rapid switching (race condition fix)',
      build: () {
        // 'ja' is not cached, it will take some time
        when(mockCheckLanguageCachedUseCase('ja')).thenAnswer((_) async => false);
        when(mockGetDynamicLocalizationUseCase('ja')).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 20));
          return const Right(null);
        });

        // 'vi' is cached (default), it should execute immediately
        when(mockCheckLanguageCachedUseCase('vi')).thenAnswer((_) async => true);
        when(mockGetDynamicLocalizationUseCase('vi')).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) async {
        bloc.add(const SettingsAction.changeLanguage(languageCode: 'ja'));
        await Future.delayed(const Duration(milliseconds: 5));
        bloc.add(const SettingsAction.changeLanguage(languageCode: 'vi'));
      },
      wait: const Duration(milliseconds: 50),
      verify: (_) {
        // Ensure that 'vi' won the race
        expect(LocalizationManager.instance.currentLocale.languageCode, 'vi');
        verifyNever(mockUpdateUserLanguageUseCase('ja'));
        verify(mockUpdateUserLanguageUseCase('vi')).called(1);
      },
    );
  });
}
