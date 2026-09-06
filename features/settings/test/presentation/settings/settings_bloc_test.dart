// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart' hide test;
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings/data/models/sync/sync_bootstrap_response.dart';
import 'package:settings/domain/entities/language_sync_status.dart';
import 'package:settings/domain/entities/supported_language.dart';
import 'package:settings/domain/usecases/bootstrap_usecase.dart';
import 'package:settings/domain/usecases/change_language_usecase.dart';
import 'package:settings/domain/usecases/get_cached_languages_usecase.dart';
import 'package:settings/domain/usecases/toggle_dark_mode_usecase.dart';
import 'package:settings/presentation/settings/settings_action.dart';
import 'package:settings/presentation/settings/settings_bloc.dart';
import 'package:settings/presentation/settings/settings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_bloc_test.mocks.dart';

@GenerateMocks([
  AppInfoService,
  ChangeLanguageUseCase,
  GetCachedLanguagesUseCase,
  BootstrapUseCase,
  ToggleDarkModeUseCase,
])
void main() {
  late SettingsBloc bloc;
  late MockAppInfoService mockAppInfoService;
  late MockChangeLanguageUseCase mockChangeLanguageUseCase;
  late MockGetCachedLanguagesUseCase mockGetCachedLanguagesUseCase;
  late MockBootstrapUseCase mockBootstrapUseCase;
  late MockToggleDarkModeUseCase mockToggleDarkModeUseCase;

  const defaultLanguages = [
    SupportedLanguage(
      languageCode: 'en',
      languageName: 'English',
      isDefault: true,
      isActive: true,
      isCached: true,
    ),
    SupportedLanguage(
      languageCode: 'vi',
      languageName: 'Tiếng Việt',
      isDefault: false,
      isActive: true,
      isCached: true,
    ),
  ];

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    D3NexusLogger.initialize(LogManagerImpl());

    mockAppInfoService = MockAppInfoService();
    mockChangeLanguageUseCase = MockChangeLanguageUseCase();
    mockGetCachedLanguagesUseCase = MockGetCachedLanguagesUseCase();
    mockBootstrapUseCase = MockBootstrapUseCase();
    mockToggleDarkModeUseCase = MockToggleDarkModeUseCase();

    when(mockAppInfoService.getPackageInfo()).thenAnswer(
      (_) async => PackageInfo(
        appName: 'Insight',
        packageName: 'com.example.insight',
        version: '1.0.0',
        buildNumber: '1',
      ),
    );
    when(mockGetCachedLanguagesUseCase()).thenAnswer(
      (_) async => const Right(defaultLanguages),
    );
    when(mockBootstrapUseCase()).thenAnswer(
      (_) async => const Right(SyncBootstrapResponse(availableLanguages: [])),
    );
    when(
      mockChangeLanguageUseCase(any),
    ).thenAnswer((_) => Stream.value(const LanguageSyncStatus.success('en')));
    when(
      mockToggleDarkModeUseCase.call(isEnabled: anyNamed('isEnabled')),
    ).thenAnswer((_) async {});

    bloc = SettingsBloc(
      mockAppInfoService,
      mockGetCachedLanguagesUseCase,
      mockBootstrapUseCase,
      mockChangeLanguageUseCase,
      mockToggleDarkModeUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be initial', () {
    expect(bloc.state.status, SettingsStatus.initial);
  });

  blocTest<SettingsBloc, SettingsState>(
    'emits [success] immediately (instant Frame-0) when started is added',
    build: () => bloc,
    act: (bloc) => bloc.add(const SettingsAction.started()),
    expect: () => [
      isA<SettingsState>()
          .having((s) => s.status, 'status', SettingsStatus.success)
          .having((s) => s.uiModel?.appVersion, 'appVersion', '1.0.0')
          .having((s) => s.uiModel?.availableLanguages.length, 'availableLanguages length', 2),
    ],
    verify: (_) {
      verify(mockAppInfoService.getPackageInfo()).called(1);
      verify(mockGetCachedLanguagesUseCase()).called(greaterThanOrEqualTo(1));
      verify(mockBootstrapUseCase()).called(1);
    },
  );

  group('changeLanguage', () {
    blocTest<SettingsBloc, SettingsState>(
      'emits [success] when language is cached (optimistic update)',
      build: () {
        when(mockChangeLanguageUseCase('ko')).thenAnswer(
          (_) => Stream.fromIterable([
            const LanguageSyncStatus.cachedApplied('ko'),
            const LanguageSyncStatus.success('ko'),
          ]),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const SettingsAction.changeLanguage(languageCode: 'ko')),
      wait: const Duration(milliseconds: 10),
      expect: () => [const SettingsState(status: SettingsStatus.success)],
      verify: (_) {
        verify(mockChangeLanguageUseCase('ko')).called(1);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'emits [loading, success] when language is NOT cached',
      build: () {
        when(mockChangeLanguageUseCase('ja')).thenAnswer(
          (_) => Stream.fromIterable([
            const LanguageSyncStatus.loading('ja'),
            const LanguageSyncStatus.success('ja'),
          ]),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const SettingsAction.changeLanguage(languageCode: 'ja')),
      wait: const Duration(milliseconds: 10),
      expect: () => [
        const SettingsState(status: SettingsStatus.loading),
        const SettingsState(status: SettingsStatus.success),
      ],
      verify: (_) {
        verify(mockChangeLanguageUseCase('ja')).called(1);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'ignores outdated language requests during rapid switching (race condition fix)',
      build: () {
        when(mockChangeLanguageUseCase('ja')).thenAnswer((_) async* {
          yield const LanguageSyncStatus.loading('ja');
          await Future.delayed(const Duration(milliseconds: 20));
          yield const LanguageSyncStatus.success('ja');
        });

        when(mockChangeLanguageUseCase('vi')).thenAnswer((_) async* {
          yield const LanguageSyncStatus.cachedApplied('vi');
          yield const LanguageSyncStatus.success('vi');
        });
        return bloc;
      },
      act: (bloc) async {
        bloc.add(const SettingsAction.changeLanguage(languageCode: 'ja'));
        await Future.delayed(const Duration(milliseconds: 5));
        bloc.add(const SettingsAction.changeLanguage(languageCode: 'vi'));
      },
      wait: const Duration(milliseconds: 50),
      expect: () => [
        // From 'ja' loading
        const SettingsState(status: SettingsStatus.loading),
        // From 'vi' cachedApplied
        const SettingsState(status: SettingsStatus.success),
      ],
      verify: (_) {
        verify(mockChangeLanguageUseCase('ja')).called(1);
        verify(mockChangeLanguageUseCase('vi')).called(1);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'emits no UI state changes when switching to SAME language (silent completion)',
      build: () {
        when(mockChangeLanguageUseCase('ko')).thenAnswer((_) => const Stream.empty());
        return bloc;
      },
      act: (bloc) => bloc.add(const SettingsAction.changeLanguage(languageCode: 'ko')),
      wait: const Duration(milliseconds: 10),
      expect: () => [],
      verify: (_) {
        verify(mockChangeLanguageUseCase('ko')).called(1);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'emits showError event when usecase yields error',
      build: () {
        when(mockChangeLanguageUseCase('fr')).thenAnswer(
          (_) => Stream.fromIterable([
            const LanguageSyncStatus.loading('fr'),
            const LanguageSyncStatus.error('fr', 'Network error'),
          ]),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const SettingsAction.changeLanguage(languageCode: 'fr')),
      wait: const Duration(milliseconds: 10),
      expect: () => [
        const SettingsState(status: SettingsStatus.loading),
        const SettingsState(status: SettingsStatus.success),
      ],
      verify: (_) {
        verify(mockChangeLanguageUseCase('fr')).called(1);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'emits updated uiModel with isDarkModeEnabled and calls ToggleDarkModeUseCase when toggleDarkMode is added',
      build: () => bloc,
      act: (bloc) => bloc.add(const SettingsAction.toggleDarkMode(isEnabled: true)),
      verify: (_) {
        verify(mockToggleDarkModeUseCase(isEnabled: true)).called(1);
      },
      expect: () => [
        predicate<SettingsState>((state) => state.uiModel?.isDarkModeEnabled == true),
      ],
    );
  });
}
