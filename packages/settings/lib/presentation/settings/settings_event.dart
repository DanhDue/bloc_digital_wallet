// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_event.freezed.dart';

@freezed
sealed class SettingsEvent extends BaseEvent with _$SettingsEvent {
  const SettingsEvent._() : super();

  const factory SettingsEvent.initial() = SettingsEventInitial;
  const factory SettingsEvent.navigateToProfile() = SettingsEventNavigateToProfile;
  const factory SettingsEvent.navigateToSecurity() = SettingsEventNavigateToSecurity;
  const factory SettingsEvent.showError({required String message}) = SettingsEventShowError;
}
