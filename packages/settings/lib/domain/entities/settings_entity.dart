// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_entity.freezed.dart';

@freezed
abstract class SettingsEntity with _$SettingsEntity {
  const SettingsEntity._();

  const factory SettingsEntity({
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
  }) = _SettingsEntity;
}
