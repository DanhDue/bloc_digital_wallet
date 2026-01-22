import 'package:bloc_digital_wallet/core/architecture/architecture.dart';

sealed class D3VotionAction extends BaseAction {
  const D3VotionAction();
}

class InitD3VotionAction extends D3VotionAction {
  const InitD3VotionAction();
}

class GetD3VotionAction extends D3VotionAction {
  final String word;
  const GetD3VotionAction(this.word);
}
