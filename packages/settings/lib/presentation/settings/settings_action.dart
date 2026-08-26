// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_action.freezed.dart';

@freezed
abstract class SettingsAction extends BaseAction with _$SettingsAction {
  const SettingsAction._();

  const factory SettingsAction.started() = SettingsActionStarted;
  const factory SettingsAction.toggleDarkMode({required bool isEnabled}) =
      SettingsActionToggleDarkMode;
  const factory SettingsAction.toggleBiometric({required bool isEnabled}) =
      SettingsActionToggleBiometric;
  const factory SettingsAction.toggleNotifications({required bool isEnabled}) =
      SettingsActionToggleNotifications;
  const factory SettingsAction.toggleDeveloperMode({required bool isEnabled}) =
      SettingsActionToggleDeveloperMode;
  const factory SettingsAction.changeCurrency({required String currency}) =
      SettingsActionChangeCurrency;
  const factory SettingsAction.changeLanguage({required String languageCode}) =
      SettingsActionChangeLanguage;
  const factory SettingsAction.navigateToProfile() = SettingsActionNavigateToProfile;
  const factory SettingsAction.navigateToSecurity() = SettingsActionNavigateToSecurity;
}
