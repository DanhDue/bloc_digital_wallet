// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framework/framework.dart';
import 'package:injectable/injectable.dart';
// import 'package:settings/domain/usecases/get_settings_usecase.dart';
import 'package:settings/presentation/settings/models/settings_ui_model.dart';

import 'settings_action.dart';
import 'settings_event.dart';
import 'settings_state.dart';

@injectable
class SettingsBloc extends MviBloc<SettingsAction, SettingsState, SettingsEvent> {
  // final GetSettingsUseCase _getSettingsUseCase;
  final AppInfoService _appInfoService;

  SettingsBloc(/* this._getSettingsUseCase, */ this._appInfoService)
    : super(const SettingsState()) {
    on<SettingsActionStarted>(_onStarted);
    on<SettingsActionNavigateToProfile>(_onNavigateToProfile);
    on<SettingsActionNavigateToSecurity>(_onNavigateToSecurity);
    on<SettingsActionToggleDarkMode>(_onToggleDarkMode);
    on<SettingsActionToggleBiometric>(_onToggleBiometric);
    on<SettingsActionToggleNotifications>(_onToggleNotifications);
    on<SettingsActionToggleDeveloperMode>(_onToggleDeveloperMode);
    on<SettingsActionChangeCurrency>(_onChangeCurrency);
  }

  Future<void> _onStarted(SettingsActionStarted action, Emitter<SettingsState> emit) async {
    // Emit loading state immediately
    emit(state.copyWith(status: SettingsStatus.loading));

    // Get app info immediately
    final packageInfo = await _appInfoService.getPackageInfo();
    final initialUiModel = SettingsUiModel(
      id: 'local',
      appVersion: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
    );

    // Emit initial state with app info visible immediately
    emit(state.copyWith(status: SettingsStatus.success, uiModel: initialUiModel));

    // Fetch full settings from API in background - DISABLED
    /*
    final result = await _getSettingsUseCase();

    result.fold(
      (failure) {
        // Log the error, show snackbar, and update state status
        Log.e('Failed to load settings: ${failure.message}');
        emitEvent(SettingsEvent.showError(message: failure.message));
        emit(state.copyWith(status: SettingsStatus.failure, errorMessage: failure.message));
      },
      (entity) {
        // Merge API data with local app info
        final uiModel = SettingsUiModel.fromEntity(
          entity,
        ).copyWith(appVersion: packageInfo.version, buildNumber: packageInfo.buildNumber);
        emit(state.copyWith(status: SettingsStatus.success, uiModel: uiModel));
      },
    );
    */
  }

  void _onToggleDarkMode(SettingsActionToggleDarkMode action, Emitter<SettingsState> emit) {
    final updatedModel = state.uiModel?.copyWith(isDarkModeEnabled: action.isEnabled);
    emit(state.copyWith(uiModel: updatedModel));
  }

  void _onToggleBiometric(SettingsActionToggleBiometric action, Emitter<SettingsState> emit) {
    final updatedModel = state.uiModel?.copyWith(isBiometricEnabled: action.isEnabled);
    emit(state.copyWith(uiModel: updatedModel));
  }

  void _onToggleNotifications(
    SettingsActionToggleNotifications action,
    Emitter<SettingsState> emit,
  ) {
    final updatedModel = state.uiModel?.copyWith(isNotificationsEnabled: action.isEnabled);
    emit(state.copyWith(uiModel: updatedModel));
  }

  void _onToggleDeveloperMode(
    SettingsActionToggleDeveloperMode action,
    Emitter<SettingsState> emit,
  ) {
    final updatedModel = state.uiModel?.copyWith(isDeveloperModeEnabled: action.isEnabled);
    emit(state.copyWith(uiModel: updatedModel));
  }

  void _onChangeCurrency(SettingsActionChangeCurrency action, Emitter<SettingsState> emit) {
    final updatedModel = state.uiModel?.copyWith(selectedCurrency: action.currency);
    emit(state.copyWith(uiModel: updatedModel));
  }

  void _onNavigateToProfile(SettingsActionNavigateToProfile action, Emitter<SettingsState> emit) {
    emitEvent(const SettingsEvent.navigateToProfile());
  }

  void _onNavigateToSecurity(
    SettingsActionNavigateToSecurity action,
    Emitter<SettingsState> emit,
  ) {
    emitEvent(const SettingsEvent.navigateToSecurity());
  }
}
