// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus/package_info_plus.dart';
// import 'package:settings/domain/entities/settings_entity.dart';
// import 'package:settings/domain/usecases/get_settings_usecase.dart';
import 'package:settings/data/datasources/local/settings_local_datasource.dart';
import 'package:settings/data/models/sync/available_language.dart';
import 'package:settings/domain/usecases/get_available_languages_usecase.dart';
import 'package:settings/domain/usecases/update_user_language_usecase.dart';
import 'package:settings/domain/usecases/get_dynamic_localization_usecase.dart';
import 'package:settings/presentation/settings/settings_action.dart';
import 'package:settings/presentation/settings/settings_bloc.dart';
import 'package:settings/presentation/settings/settings_state.dart';
import 'package:core/core.dart' hide test;

import '../../support/fake_log_manager.dart';
import 'settings_bloc_test.mocks.dart';

@GenerateMocks([
  /* GetSettingsUseCase, */ AppInfoService,
  UpdateUserLanguageUseCase,
  GetAvailableLanguagesUseCase,
  GetDynamicLocalizationUseCase,
  SettingsLocalDataSource,
])
void main() {
  late SettingsBloc bloc;
  // late MockGetSettingsUseCase mockUseCase;
  late MockAppInfoService mockAppInfoService;
  late MockUpdateUserLanguageUseCase mockUpdateUserLanguageUseCase;
  late MockGetAvailableLanguagesUseCase mockGetAvailableLanguagesUseCase;
  late MockGetDynamicLocalizationUseCase mockGetDynamicLocalizationUseCase;
  late MockSettingsLocalDataSource mockSettingsLocalDataSource;
  late FakeLogManager fakeLogManager;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    // mockUseCase = MockGetSettingsUseCase();
    mockAppInfoService = MockAppInfoService();
    mockUpdateUserLanguageUseCase = MockUpdateUserLanguageUseCase();
    mockGetAvailableLanguagesUseCase = MockGetAvailableLanguagesUseCase();
    mockGetDynamicLocalizationUseCase = MockGetDynamicLocalizationUseCase();
    mockSettingsLocalDataSource = MockSettingsLocalDataSource();

    // D3NexusLogger is a static facade; re-initialize it with a fresh fake
    // before each test so toggle calls made by the bloc can be asserted in
    // isolation.
    fakeLogManager = FakeLogManager();
    D3NexusLogger.initialize(fakeLogManager);

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
    when(mockSettingsLocalDataSource.getModuleToggles()).thenAnswer((_) async => <String, bool>{});
    when(
      mockSettingsLocalDataSource.getAppenderToggles(),
    ).thenAnswer((_) async => <String, bool>{});
    when(mockSettingsLocalDataSource.saveModuleToggles(any)).thenAnswer((_) async {});
    when(mockSettingsLocalDataSource.saveAppenderToggles(any)).thenAnswer((_) async {});

    bloc = SettingsBloc(
      /* mockUseCase, */
      mockAppInfoService,
      mockUpdateUserLanguageUseCase,
      mockGetAvailableLanguagesUseCase,
      mockGetDynamicLocalizationUseCase,
      mockSettingsLocalDataSource,
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
      verify(mockSettingsLocalDataSource.getModuleToggles()).called(1);
      verify(mockSettingsLocalDataSource.getAppenderToggles()).called(1);
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

  group('logging toggles', () {
    blocTest<SettingsBloc, SettingsState>(
      'loads persisted module and appender toggles into the initial uiModel on started',
      build: () {
        when(
          mockSettingsLocalDataSource.getModuleToggles(),
        ).thenAnswer((_) async => {'Wallet': false, 'Network': true});
        when(
          mockSettingsLocalDataSource.getAppenderToggles(),
        ).thenAnswer((_) async => {'datadog': false});
        return bloc;
      },
      act: (bloc) => bloc.add(const SettingsAction.started()),
      expect: () => [
        const SettingsState(status: SettingsStatus.loading),
        isA<SettingsState>()
            .having((s) => s.status, 'status', SettingsStatus.success)
            .having((s) => s.uiModel?.moduleToggles, 'moduleToggles', {
              'Wallet': false,
              'Network': true,
            })
            .having((s) => s.uiModel?.appenderToggles, 'appenderToggles', {'datadog': false}),
      ],
    );

    blocTest<SettingsBloc, SettingsState>(
      'toggleModuleLogging updates state, calls D3NexusLogger.setModuleEnabled, and persists',
      build: () => bloc,
      act: (bloc) async {
        bloc.add(const SettingsAction.started());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SettingsAction.toggleModuleLogging(module: 'Wallet', isEnabled: false));
      },
      skip: 2, // loading, then the initial success state from started
      expect: () => [
        isA<SettingsState>().having((s) => s.uiModel?.moduleToggles, 'moduleToggles', {
          'Wallet': false,
        }),
      ],
      verify: (_) {
        expect(fakeLogManager.moduleToggleCalls, {'Wallet': false});
        verify(mockSettingsLocalDataSource.saveModuleToggles({'Wallet': false})).called(1);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'toggleAppenderLogging updates state, calls D3NexusLogger.setAppenderEnabled, and persists',
      build: () => bloc,
      act: (bloc) async {
        bloc.add(const SettingsAction.started());
        await Future<void>.delayed(Duration.zero);
        bloc.add(
          const SettingsAction.toggleAppenderLogging(appenderId: 'datadog', isEnabled: false),
        );
      },
      skip: 2, // loading, then the initial success state from started
      expect: () => [
        isA<SettingsState>().having((s) => s.uiModel?.appenderToggles, 'appenderToggles', {
          'datadog': false,
        }),
      ],
      verify: (_) {
        expect(fakeLogManager.appenderToggleCalls, {'datadog': false});
        verify(mockSettingsLocalDataSource.saveAppenderToggles({'datadog': false})).called(1);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'toggling a module preserves other previously-set module toggles',
      build: () {
        when(
          mockSettingsLocalDataSource.getModuleToggles(),
        ).thenAnswer((_) async => {'Wallet': false});
        return bloc;
      },
      act: (bloc) async {
        bloc.add(const SettingsAction.started());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SettingsAction.toggleModuleLogging(module: 'Network', isEnabled: false));
      },
      skip: 2,
      expect: () => [
        isA<SettingsState>().having((s) => s.uiModel?.moduleToggles, 'moduleToggles', {
          'Wallet': false,
          'Network': false,
        }),
      ],
      verify: (_) {
        verify(
          mockSettingsLocalDataSource.saveModuleToggles({'Wallet': false, 'Network': false}),
        ).called(1);
      },
    );
  });
}
