// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

part 'translation_override_response.freezed.dart';
part 'translation_override_response.g.dart';

@freezed
abstract class TranslationOverrideData with _$TranslationOverrideData {
  const factory TranslationOverrideData({
    @JsonKey(name: 'version') required String version,
    @JsonKey(name: 'translations') required Map<String, dynamic> translations,
  }) = _TranslationOverrideData;

  factory TranslationOverrideData.fromJson(Map<String, dynamic> json) =>
      _$TranslationOverrideDataFromJson(json);
}
