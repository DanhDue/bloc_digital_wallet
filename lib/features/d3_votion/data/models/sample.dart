import 'package:freezed_annotation/freezed_annotation.dart';

part 'sample.freezed.dart';
part 'sample.g.dart';

@freezed
abstract class Sample with _$Sample {
  @JsonSerializable(includeIfNull: false)
  const factory Sample({
    String? text,
    @JsonKey(name: 'vietnamese_text') String? vietnameseText,
    @JsonKey(name: 'audio_link') String? audioLink,
  }) = _Sample;

  factory Sample.fromJson(Map<String, dynamic> json) =>
      _$SampleFromJson(json);
}
