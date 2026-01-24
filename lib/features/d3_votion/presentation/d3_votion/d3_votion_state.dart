import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc_digital_wallet/core/architecture/mvi_base.dart';
import 'package:bloc_digital_wallet/features/d3_votion/domain/entities/d3_votion_entity.dart';

part 'd3_votion_state.freezed.dart';

@freezed
abstract class D3VotionState with _$D3VotionState implements BaseState {
  const factory D3VotionState.initial() = D3VotionInitial;
  const factory D3VotionState.loading() = D3VotionLoading;
  const factory D3VotionState.loaded(D3VotionEntity data) = D3VotionLoaded;
  const factory D3VotionState.failure(String message) = D3VotionFailure;
}
