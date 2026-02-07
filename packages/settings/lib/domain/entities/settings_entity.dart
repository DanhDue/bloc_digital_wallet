// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_entity.freezed.dart';
part 'settings_entity.g.dart';

@freezed
abstract class SettingsEntity with _$SettingsEntity {
  const factory SettingsEntity({
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
  }) = _SettingsEntity;

  factory SettingsEntity.fromJson(Map<String, dynamic> json) => _$SettingsEntityFromJson(json);
}
