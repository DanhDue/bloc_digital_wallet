// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

part 'd3_votion_sample.freezed.dart';
part 'd3_votion_sample.g.dart';

@freezed
abstract class D3VotionSample with _$D3VotionSample {
  @JsonSerializable(includeIfNull: false)
  const factory D3VotionSample({
    @JsonKey(name: 'text') String? text,
    @JsonKey(name: 'vietnamese_text') String? vietnameseText,
    @JsonKey(name: 'audio_link') String? audioLink,
  }) = _D3VotionSample;

  factory D3VotionSample.fromJson(Map<String, dynamic> json) =>
      _$D3VotionSampleFromJson(json);
}
