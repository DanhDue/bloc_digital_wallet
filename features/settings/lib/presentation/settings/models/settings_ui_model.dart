// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:settings/domain/entities/settings_entity.dart';
import 'package:settings/domain/entities/supported_language.dart';

part 'settings_ui_model.freezed.dart';

@freezed
abstract class SettingsUiModel with _$SettingsUiModel {
  const factory SettingsUiModel({
    required String id,
    String? userName,
    String? email,
    @Default(false) bool isDarkModeEnabled,
    @Default(false) bool isBiometricEnabled,
    @Default('USD') String selectedCurrency,
    @Default(true) bool isNotificationsEnabled,
    @Default(false) bool isDeveloperModeEnabled,
    String? appVersion,
    String? buildNumber,
    @Default([]) List<SupportedLanguage> availableLanguages,
  }) = _SettingsUiModel;

  factory SettingsUiModel.fromEntity(SettingsEntity entity) {
    return SettingsUiModel(
      id: entity.id,
      userName: entity.userName,
      email: entity.email,
      isDarkModeEnabled: entity.isDarkModeEnabled,
      isBiometricEnabled: entity.isBiometricEnabled,
      selectedCurrency: entity.selectedCurrency,
      isNotificationsEnabled: entity.isNotificationsEnabled,
      isDeveloperModeEnabled: entity.isDeveloperModeEnabled,
      appVersion: entity.appVersion,
      buildNumber: entity.buildNumber,
    );
  }
}
