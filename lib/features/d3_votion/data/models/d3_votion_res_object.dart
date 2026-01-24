import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc_digital_wallet/features/d3_votion/data/models/sample.dart';

part 'd3_votion_res_object.freezed.dart';
part 'd3_votion_res_object.g.dart';

@freezed
abstract class D3VotionResObject with _$D3VotionResObject {
  @JsonSerializable(includeIfNull: false)
  const factory D3VotionResObject({
    String? word,
    String? definition,
    String? ipa,
    List<Sample>? samples,
  }) = _D3VotionResObject;

  factory D3VotionResObject.fromJson(Map<String, dynamic> json) =>
      _$D3VotionResObjectFromJson(json);
}
