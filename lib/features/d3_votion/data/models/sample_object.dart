// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sample_object.freezed.dart';
part 'sample_object.g.dart';

@freezed
abstract class SampleObject with _$SampleObject {
  @JsonSerializable(includeIfNull: false)
  const factory SampleObject({
    @JsonKey(name: 'text') String? text,
    @JsonKey(name: 'vietnamese_text') String? vietnameseText,
    @JsonKey(name: 'audio_link') String? audioLink,
  }) = _SampleObject;

  factory SampleObject.fromJson(Map<String, Object?> json) =>
      _$SampleObjectFromJson(json);
}
