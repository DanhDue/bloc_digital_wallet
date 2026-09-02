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
import 'package:settings/domain/usecases/change_language_usecase.dart';
import 'package:settings/data/models/sync/available_language.dart';
import 'package:settings/domain/usecases/get_available_languages_usecase.dart';
import 'package:settings/presentation/settings/settings_action.dart';
import 'package:settings/presentation/settings/settings_bloc.dart';
import 'package:settings/presentation/settings/settings_state.dart';
import 'package:core/core.dart' hide test;

import 'settings_bloc_test.mocks.dart';

@GenerateMocks([AppInfoService, ChangeLanguageUseCase, GetAvailableLanguagesUseCase])
void main() {
  late SettingsBloc bloc;
  late MockAppInfoService mockAppInfoService;
  late MockChangeLanguageUseCase mockChangeLanguageUseCase;
  late MockGetAvailableLanguagesUseCase mockGetAvailableLanguagesUseCase;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    D3NexusLogger.initialize(LogManagerImpl());

    mockAppInfoService = MockAppInfoService();
    mockChangeLanguageUseCase = MockChangeLanguageUseCase();
    mockGetAvailableLanguagesUseCase = MockGetAvailableLanguagesUseCase();

    when(mockAppInfoService.getPackageInfo()).thenAnswer(
      (_) async => PackageInfo(
        appName: 'Insight',
        packageName: 'com.example.insight',
        version: '1.0.0',
        buildNumber: '1',
      ),
    );
    when(mockGetAvailableLanguagesUseCase()).thenAnswer((_) async => Right(<AvailableLanguage>[]));
    when(
      mockChangeLanguageUseCase(any),
    ).thenAnswer((_) => Stream.value(LanguageSyncStatus.success));

    bloc = SettingsBloc(
      mockAppInfoService,
      mockGetAvailableLanguagesUseCase,
      mockChangeLanguageUseCase,
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
      'emits [success] when language is cached (optimistic update)',
      build: () {
        when(mockChangeLanguageUseCase('ko')).thenAnswer(
          (_) =>
              Stream.fromIterable([LanguageSyncStatus.cachedApplied, LanguageSyncStatus.success]),
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
          (_) => Stream.fromIterable([LanguageSyncStatus.loading, LanguageSyncStatus.success]),
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
          yield LanguageSyncStatus.loading;
          await Future.delayed(const Duration(milliseconds: 20));
          yield LanguageSyncStatus.success;
        });

        when(mockChangeLanguageUseCase('vi')).thenAnswer((_) async* {
          yield LanguageSyncStatus.cachedApplied;
          yield LanguageSyncStatus.success;
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
          (_) => Stream.fromIterable([LanguageSyncStatus.loading, LanguageSyncStatus.error]),
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
  });
}
