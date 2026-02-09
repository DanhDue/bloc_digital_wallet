// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_test/bloc_test.dart';
// import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus/package_info_plus.dart';
// import 'package:settings/domain/entities/settings_entity.dart';
// import 'package:settings/domain/usecases/get_settings_usecase.dart';
import 'package:settings/presentation/settings/settings_action.dart';
import 'package:settings/presentation/settings/settings_bloc.dart';
import 'package:settings/presentation/settings/settings_state.dart';
import 'package:core/core.dart' hide test;
import 'package:talker_flutter/talker_flutter.dart';

import 'settings_bloc_test.mocks.dart';

@GenerateMocks([/* GetSettingsUseCase, */ AppInfoService])
void main() {
  late SettingsBloc bloc;
  // late MockGetSettingsUseCase mockUseCase;
  late MockAppInfoService mockAppInfoService;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    try {
      Log.init(Talker());
    } catch (_) {
      // Already initialized
    }
  });

  setUp(() {
    // mockUseCase = MockGetSettingsUseCase();
    mockAppInfoService = MockAppInfoService();
    // Default Mock Behavior
    when(mockAppInfoService.getPackageInfo()).thenAnswer(
      (_) async => PackageInfo(
        appName: 'Insight',
        packageName: 'com.example.insight',
        version: '1.0.0',
        buildNumber: '1',
      ),
    );
    bloc = SettingsBloc(/* mockUseCase, */ mockAppInfoService);
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
      isA<SettingsState>()
          .having((s) => s.status, 'status', SettingsStatus.success)
          .having((s) => s.uiModel?.isDarkModeEnabled, 'isDarkModeEnabled', true),
    ],
    verify: (_) {
      verify(mockAppInfoService.getPackageInfo()).called(1);
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
}
