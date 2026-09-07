// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:framework/framework.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings/domain/entities/language_sync_status.dart';
import 'package:settings/domain/entities/supported_language.dart';
import 'package:settings/domain/usecases/bootstrap_usecase.dart';
import 'package:settings/domain/usecases/change_language_usecase.dart';
import 'package:settings/domain/usecases/get_cached_languages_usecase.dart';
import 'package:settings/domain/usecases/toggle_dark_mode_usecase.dart';
import 'package:settings/presentation/settings/models/settings_ui_model.dart';

import 'settings_action.dart';
import 'settings_event.dart';
import 'settings_state.dart';

@injectable
class SettingsBloc extends MviBloc<SettingsAction, SettingsState, SettingsEvent> {
  final AppInfoService _appInfoService;
  final GetCachedLanguagesUseCase _getCachedLanguagesUseCase;
  final BootstrapUseCase _bootstrapUseCase;
  final ChangeLanguageUseCase _changeLanguageUseCase;
  final ToggleDarkModeUseCase _toggleDarkModeUseCase;

  String? _pendingLanguageCode;

  SettingsBloc(
    this._appInfoService,
    this._getCachedLanguagesUseCase,
    this._bootstrapUseCase,
    this._changeLanguageUseCase,
    this._toggleDarkModeUseCase,
  ) : super(const SettingsState()) {
    on<SettingsActionStarted>(_onStarted);
    on<SettingsActionNavigateToProfile>(_onNavigateToProfile);
    on<SettingsActionNavigateToSecurity>(_onNavigateToSecurity);
    on<SettingsActionToggleDarkMode>(_onToggleDarkMode);
    on<SettingsActionToggleBiometric>(_onToggleBiometric);
    on<SettingsActionToggleNotifications>(_onToggleNotifications);
    on<SettingsActionToggleDeveloperMode>(_onToggleDeveloperMode);
    on<SettingsActionChangeCurrency>(_onChangeCurrency);
    on<SettingsActionChangeLanguage>(_onChangeLanguage, transformer: restartable());
  }

  Future<void> _onStarted(SettingsActionStarted action, Emitter<SettingsState> emit) async {
    // 1. Instant Frame-0: get package info and cached languages
    final results = await Future.wait([
      _appInfoService.getPackageInfo(),
      _getCachedLanguagesUseCase(),
    ]);

    final packageInfo = results[0] as PackageInfo;
    final languagesResult = results[1] as Either<Failure, List<SupportedLanguage>>;
    final cachedLanguages = languagesResult.getOrElse(
      () => GetCachedLanguagesUseCase.defaultBundledLanguages,
    );

    final initialUiModel = SettingsUiModel(
      id: 'local',
      appVersion: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
      isDarkModeEnabled: ThemeManager.instance.isDarkMode,
      availableLanguages: cachedLanguages,
    );

    // Frame-0: Instant render without modal loading dialog
    emit(state.copyWith(status: SettingsStatus.success, uiModel: initialUiModel));

    // 2. Silent background bootstrap
    await _runBackgroundBootstrap(emit);
  }

  Future<void> _runBackgroundBootstrap(Emitter<SettingsState> emit) async {
    final bootstrapResult = await _bootstrapUseCase();
    await bootstrapResult.fold(
      (failure) async => null, // Stale cache is fine, silently proceed
      (response) async {
        final refreshedLanguagesResult = await _getCachedLanguagesUseCase();
        refreshedLanguagesResult.fold((failure) => null, (refreshedLanguages) {
          if (!isClosed) {
            final updatedModel = state.uiModel?.copyWith(availableLanguages: refreshedLanguages);
            emit(state.copyWith(uiModel: updatedModel));
          }
        });
      },
    );
  }

  Future<void> _onToggleDarkMode(
    SettingsActionToggleDarkMode action,
    Emitter<SettingsState> emit,
  ) async {
    final currentModel = state.uiModel ?? const SettingsUiModel(id: 'local');
    final updatedModel = currentModel.copyWith(isDarkModeEnabled: action.isEnabled);
    emit(state.copyWith(uiModel: updatedModel));

    await _toggleDarkModeUseCase(isEnabled: action.isEnabled);
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
    final langCode = action.languageCode;
    _pendingLanguageCode = langCode;

    await emit.forEach<LanguageSyncStatus>(
      _changeLanguageUseCase(langCode),
      onData: (status) {
        if (_pendingLanguageCode != langCode) {
          return state; // Ignore updates if a newer language was clicked
        }

        switch (status) {
          case LanguageSyncIdle():
            return state;
          case LanguageSyncLoading():
            return state.copyWith(status: SettingsStatus.loading);
          case LanguageSyncCachedApplied():
          case LanguageSyncSuccess():
            return state.copyWith(status: SettingsStatus.success);
          case LanguageSyncError(:final message):
            emitEvent(SettingsEvent.showError(message: message));
            return state.copyWith(status: SettingsStatus.success);
        }
      },
    );
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
