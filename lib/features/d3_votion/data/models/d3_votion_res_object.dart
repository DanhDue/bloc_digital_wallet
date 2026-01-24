// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc_digital_wallet/features/d3_votion/data/models/sample_object.dart';

part 'd3_votion_res_object.freezed.dart';
part 'd3_votion_res_object.g.dart';

@freezed
abstract class D3VotionResObject with _$D3VotionResObject {
  @JsonSerializable(includeIfNull: false)
  const factory D3VotionResObject({
    @JsonKey(name: 'word') String? word,
    @JsonKey(name: 'definition') String? definition,
    @JsonKey(name: 'ipa') String? ipa,
    @JsonKey(name: 'samples') List<SampleObject>? samples,
  }) = _D3VotionResObject;

  factory D3VotionResObject.fromJson(Map<String, Object?> json) =>
      _$D3VotionResObjectFromJson(json);
}
