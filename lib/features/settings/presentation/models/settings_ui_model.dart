// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_ui_model.freezed.dart';
part 'settings_ui_model.g.dart';

@freezed
sealed class SettingsUiModel with _$SettingsUiModel {
  const factory SettingsUiModel({
    required String id,
    required String name,
    // TODO: Add UI properties
  }) = _SettingsUiModel;

  factory SettingsUiModel.fromJson(Map<String, dynamic> json) => _$SettingsUiModelFromJson(json);
}
