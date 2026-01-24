import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc_digital_wallet/core/architecture/mvi_base.dart';

part 'd3_votion_action.freezed.dart';

@freezed
abstract class D3VotionAction with _$D3VotionAction implements BaseAction {
  const factory D3VotionAction.getD3Votion(String word) = GetD3VotionAction;
}
