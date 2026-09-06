// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:settings/presentation/settings/models/settings_ui_model.dart';

part 'settings_state.freezed.dart';

enum SettingsStatus { initial, loading, success, failure }

@freezed
abstract class SettingsState extends BaseState with _$SettingsState {
  const factory SettingsState({
    @Default(SettingsStatus.initial) SettingsStatus status,
    SettingsUiModel? uiModel,
    String? errorMessage,
  }) = _SettingsState;

  const SettingsState._() : super();
}
