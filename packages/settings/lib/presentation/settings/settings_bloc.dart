// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framework/framework.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings/data/models/sync/available_language.dart';
import 'package:settings/domain/usecases/get_available_languages_usecase.dart';
import 'package:settings/domain/usecases/get_dynamic_localization_usecase.dart';
import 'package:settings/domain/usecases/update_user_language_usecase.dart';
import 'package:settings/presentation/settings/models/settings_ui_model.dart';

import 'settings_action.dart';
import 'settings_event.dart';
import 'settings_state.dart';

@injectable
class SettingsBloc extends MviBloc<SettingsAction, SettingsState, SettingsEvent> {
  // final GetSettingsUseCase _getSettingsUseCase;
  final AppInfoService _appInfoService;
  final UpdateUserLanguageUseCase _updateUserLanguageUseCase;
  final GetAvailableLanguagesUseCase _getAvailableLanguagesUseCase;
  final GetDynamicLocalizationUseCase _getDynamicLocalizationUseCase;

  SettingsBloc(
    /* this._getSettingsUseCase, */
    this._appInfoService,
    this._updateUserLanguageUseCase,
    this._getAvailableLanguagesUseCase,
    this._getDynamicLocalizationUseCase,
  ) : super(const SettingsState()) {
    on<SettingsActionStarted>(_onStarted);
    on<SettingsActionNavigateToProfile>(_onNavigateToProfile);
    on<SettingsActionNavigateToSecurity>(_onNavigateToSecurity);
    on<SettingsActionToggleDarkMode>(_onToggleDarkMode);
    on<SettingsActionToggleBiometric>(_onToggleBiometric);
    on<SettingsActionToggleNotifications>(_onToggleNotifications);
    on<SettingsActionToggleDeveloperMode>(_onToggleDeveloperMode);
    on<SettingsActionChangeCurrency>(_onChangeCurrency);
    on<SettingsActionChangeLanguage>(_onChangeLanguage);
  }

  Future<void> _onStarted(SettingsActionStarted action, Emitter<SettingsState> emit) async {
    // Emit loading state immediately
    emit(state.copyWith(status: SettingsStatus.loading));

    // Get app info and available languages immediately.
    final results = await Future.wait([
      _appInfoService.getPackageInfo(),
      _getAvailableLanguagesUseCase(),
    ]);

    final packageInfo = results[0] as PackageInfo;
    final languagesResult = results[1] as Either<Failure, List<AvailableLanguage>>;
    final availableLanguages = languagesResult.getOrElse(() => <AvailableLanguage>[]);

    final initialUiModel = SettingsUiModel(
      id: 'local',
      appVersion: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
      isDarkModeEnabled: ThemeManager.instance.isDarkMode,
      availableLanguages: availableLanguages,
    );

    // Emit initial state with app info visible immediately
    emit(state.copyWith(status: SettingsStatus.success, uiModel: initialUiModel));

    // Fetch full settings from API in background - DISABLED
    /*
    final result = await _getSettingsUseCase();

    result.fold(
      (failure) {
        // Log the error, show snackbar, and update state status
        D3NexusLogger.getLogger('Settings').e('Failed to load settings: ${failure.message}');
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

    final themeMode = action.isEnabled ? ThemeMode.dark : ThemeMode.light;
    ThemeManager.instance.setThemeMode(themeMode);
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

  Future<void> _onChangeLanguage(
    SettingsActionChangeLanguage action,
    Emitter<SettingsState> emit,
  ) async {
    // 1. Switch the locale immediately (optimistic UI update) using whatever
    // bundled/cached translations are already available. Do NOT gate this on
    // the backend fetch below - a language whose dynamic content isn't
    // fetchable yet must still visibly switch in the UI.
    await LocalizationManager.instance.setLocaleFromCode(action.languageCode);

    // 2. Fetch translation JSON for the new locale and apply dynamic override
    // in the background. A failure here means the dynamic overrides didn't
    // refresh, not that the language switch itself failed - surface a softer
    // error but keep going.
    final result = await _getDynamicLocalizationUseCase(action.languageCode);
    if (result.isLeft()) {
      final failure = result.fold((l) => l, (r) => null);
      emitEvent(
        SettingsEvent.showError(
          message: failure?.message ?? 'Failed to refresh language content',
        ),
      );
    }

    // 3. Call UpdateUserLanguageUseCase in background to sync preference to server
    await _updateUserLanguageUseCase(action.languageCode);
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
