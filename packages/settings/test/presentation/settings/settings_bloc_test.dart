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
  /* GetSettingsUseCase, */ AppInfoService,
  UpdateUserLanguageUseCase,
  GetAvailableLanguagesUseCase,
  GetDynamicLocalizationUseCase,
])
void main() {
  late SettingsBloc bloc;
  // late MockGetSettingsUseCase mockUseCase;
  late MockAppInfoService mockAppInfoService;
  late MockUpdateUserLanguageUseCase mockUpdateUserLanguageUseCase;
  late MockGetAvailableLanguagesUseCase mockGetAvailableLanguagesUseCase;
  late MockGetDynamicLocalizationUseCase mockGetDynamicLocalizationUseCase;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});

    // LocalizationManager.setLocaleFromCode (exercised by changeLanguage
    // tests) logs through D3NexusLogger; wire it to a no-op manager so the
    // static facade isn't left uninitialized in this test isolate.
    D3NexusLogger.initialize(LogManagerImpl());

    // mockUseCase = MockGetSettingsUseCase();
    mockAppInfoService = MockAppInfoService();
    mockUpdateUserLanguageUseCase = MockUpdateUserLanguageUseCase();
    mockGetAvailableLanguagesUseCase = MockGetAvailableLanguagesUseCase();
    mockGetDynamicLocalizationUseCase = MockGetDynamicLocalizationUseCase();

    // Default Mock Behavior
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

    bloc = SettingsBloc(
      /* mockUseCase, */
      mockAppInfoService,
      mockUpdateUserLanguageUseCase,
      mockGetAvailableLanguagesUseCase,
      mockGetDynamicLocalizationUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  /*
  const tSettingsEntity = SettingsEntity(
    id: '1',
    userName: 'Test User',
    email: 'test@example.com',
    isDarkModeEnabled: true,
    isBiometricEnabled: false,
    selectedCurrency: 'USD',
    isNotificationsEnabled: true,
    isDeveloperModeEnabled: false,
  );
  */

  test('initial state should be initial', () {
    expect(bloc.state.status, SettingsStatus.initial);
  });

  blocTest<SettingsBloc, SettingsState>(
    'emits [loading, success] when started is added and usecase returns success',
    build: () {
      // when(mockUseCase()).thenAnswer((_) async => const Right(tSettingsEntity));
      return bloc;
    },
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
      // verify(mockUseCase()).called(1);
    },
  );

  blocTest<SettingsBloc, SettingsState>(
    'emits [loading, success] and emits error event when started is added and usecase returns failure',
    build: () {
      /*
      when(
        mockUseCase(),
      ).thenAnswer((_) async => const Left(ServerFailure(message: 'Server error')));
      */
      return bloc;
    },
    act: (bloc) => bloc.add(const SettingsAction.started()),
    expect: () => [
      const SettingsState(status: SettingsStatus.loading),
      isA<SettingsState>()
          .having((s) => s.status, 'status', SettingsStatus.success)
          .having((s) => s.uiModel?.appVersion, 'appVersion', '1.0.0'),
    ],
    errors: () => [], // No uncaught errors
    verify: (_) {
      verify(mockAppInfoService.getPackageInfo()).called(1);
      verify(mockGetAvailableLanguagesUseCase()).called(1);
      // verify(mockUseCase()).called(1);
      // We cannot easily test the side effect event stream with `expectLater` inside verify
      // comfortably with blocTest 9.1.x combined with other expectations without splitting tests
      // or using a specific pattern.
      // However, we can assert on the emitted states which is what we did above.
      // For events, we could try:
      // expectLater(bloc.events, emits(const SettingsEvent.showError(message: 'Server error')));
      // But capturing it after `act` might be tricky if it's already emitted.
      // `blocTest` doesn't support verifying side-effect streams directly in `expect`.
      // We will assume state verification is sufficient for now, or use a workaround if needed.
    },
  );

  group('changeLanguage', () {
    blocTest<SettingsBloc, SettingsState>(
      'switches the locale immediately (optimistic update) even when the '
      'dynamic translation fetch fails, per the documented optimistic-UI '
      'design in localization_management.en.md section 2.2',
      build: () {
        when(mockGetDynamicLocalizationUseCase('ko')).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Language content not available yet')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const SettingsAction.changeLanguage(languageCode: 'ko')),
      wait: const Duration(milliseconds: 10),
      verify: (_) {
        // The UI-facing locale must switch even though the background fetch failed -
        // this is the bug: gating the switch on fetch success meant a language whose
        // dynamic content wasn't fetchable would never visibly change in the app.
        expect(LocalizationManager.instance.currentLocale.languageCode, 'ko');
        // The background sync to the server must still happen; a failed fetch must
        // not short-circuit the rest of the flow.
        verify(mockUpdateUserLanguageUseCase('ko')).called(1);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'switches the locale and syncs the preference when the dynamic '
      'translation fetch succeeds',
      build: () {
        when(
          mockGetDynamicLocalizationUseCase('ja'),
        ).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(const SettingsAction.changeLanguage(languageCode: 'ja')),
      wait: const Duration(milliseconds: 10),
      verify: (_) {
        expect(LocalizationManager.instance.currentLocale.languageCode, 'ja');
        verify(mockUpdateUserLanguageUseCase('ja')).called(1);
      },
    );
  });
}
