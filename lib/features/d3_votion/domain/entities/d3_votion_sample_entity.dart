// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'd3_votion_sample_entity.freezed.dart';
part 'd3_votion_sample_entity.g.dart';

@freezed
class D3VotionSampleEntity with _$D3VotionSampleEntity {
  const factory D3VotionSampleEntity({
    @JsonKey(name: 'text') String? text,
    @JsonKey(name: 'vietnamese_text') String? vietnameseText,
    @JsonKey(name: 'audio_link') String? audioLink,
  }) = _D3VotionSampleEntity;

  factory D3VotionSampleEntity.fromJson(Map<String, dynamic> json) =>
      _$D3VotionSampleEntityFromJson(json);
}
