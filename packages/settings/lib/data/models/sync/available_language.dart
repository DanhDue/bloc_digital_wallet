// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

part 'available_language.freezed.dart';
part 'available_language.g.dart';

@freezed
abstract class AvailableLanguage with _$AvailableLanguage {
  const factory AvailableLanguage({
    @JsonKey(name: 'language_code') required String languageCode,
    @JsonKey(name: 'language_name') required String languageName,
    @JsonKey(name: 'is_default') required bool isDefault,
    @JsonKey(name: 'is_active') required bool isActive,
  }) = _AvailableLanguage;

  factory AvailableLanguage.fromJson(Map<String, dynamic> json) =>
      _$AvailableLanguageFromJson(json);
}
