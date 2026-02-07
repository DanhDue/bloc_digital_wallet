// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:settings/domain/entities/settings_entity.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

@freezed
abstract class SettingsModel with _$SettingsModel {
  const factory SettingsModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'user_name') String? userName,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'is_dark_mode_enabled') @Default(false) bool isDarkModeEnabled,
    @JsonKey(name: 'is_biometric_enabled') @Default(false) bool isBiometricEnabled,
    @JsonKey(name: 'selected_currency') @Default('USD') String selectedCurrency,
    @JsonKey(name: 'is_notifications_enabled') @Default(true) bool isNotificationsEnabled,
    @JsonKey(name: 'is_developer_mode_enabled') @Default(false) bool isDeveloperModeEnabled,
    @JsonKey(name: 'app_version') String? appVersion,
    @JsonKey(name: 'build_number') String? buildNumber,
  }) = _SettingsModel;

  factory SettingsModel.fromJson(Map<String, dynamic> json) => _$SettingsModelFromJson(json);
}

extension SettingsModelX on SettingsModel {
  SettingsEntity toEntity() {
    return SettingsEntity(
      id: id,
      userName: userName,
      email: email,
      isDarkModeEnabled: isDarkModeEnabled,
      isBiometricEnabled: isBiometricEnabled,
      selectedCurrency: selectedCurrency,
      isNotificationsEnabled: isNotificationsEnabled,
      isDeveloperModeEnabled: isDeveloperModeEnabled,
      appVersion: appVersion,
      buildNumber: buildNumber,
    );
  }
}
