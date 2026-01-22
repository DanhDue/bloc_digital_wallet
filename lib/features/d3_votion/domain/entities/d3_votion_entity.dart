import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc_digital_wallet/features/d3_votion/domain/entities/d3_votion_sample_entity.dart';

part 'd3_votion_entity.freezed.dart';
part 'd3_votion_entity.g.dart';

@freezed
class D3VotionEntity with _$D3VotionEntity {
  const factory D3VotionEntity({
    @JsonKey(name: 'word') String? word,
    @JsonKey(name: 'definition') String? definition,
    @JsonKey(name: 'ipa') String? ipa,
    @JsonKey(name: 'samples') List<D3VotionSampleEntity>? samples,
  }) = _D3VotionEntity;

  factory D3VotionEntity.fromJson(Map<String, dynamic> json) =>
      _$D3VotionEntityFromJson(json);
}
