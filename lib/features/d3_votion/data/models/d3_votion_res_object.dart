import 'package:freezed_annotation/freezed_annotation.dart';

part 'd3_votion_res_object.freezed.dart';
part 'd3_votion_res_object.g.dart';

@freezed
abstract class D3VotionResObject with _$D3VotionResObject {
  const factory D3VotionResObject({
    @JsonKey(name: 'word') String? word,
    @JsonKey(name: 'definition') String? definition,
    @JsonKey(name: 'ipa') String? ipa,
    @JsonKey(name: 'samples') List<D3VotionSampleObject>? samples,
  }) = _D3VotionResObject;

  factory D3VotionResObject.fromJson(Map<String, Object?> json) =>
      _$D3VotionResObjectFromJson(json);
}

@freezed
abstract class D3VotionSampleObject with _$D3VotionSampleObject {
  const factory D3VotionSampleObject({
    @JsonKey(name: 'text') String? text,
    @JsonKey(name: 'vietnamese_text') String? vietnameseText,
    @JsonKey(name: 'audio_link') String? audioLink,
  }) = _D3VotionSampleObject;

  factory D3VotionSampleObject.fromJson(Map<String, Object?> json) =>
      _$D3VotionSampleObjectFromJson(json);
}
