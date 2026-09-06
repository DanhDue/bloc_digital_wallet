// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

part 'bootstrap_user_preferences.freezed.dart';
part 'bootstrap_user_preferences.g.dart';

@freezed
abstract class BootstrapUserPreferences with _$BootstrapUserPreferences {
  const factory BootstrapUserPreferences({
    @JsonKey(name: 'selected_language') String? selectedLanguage,
    @JsonKey(name: 'selected_theme_id') String? selectedThemeId,
  }) = _BootstrapUserPreferences;

  factory BootstrapUserPreferences.fromJson(Map<String, dynamic> json) =>
      _$BootstrapUserPreferencesFromJson(json);
}
