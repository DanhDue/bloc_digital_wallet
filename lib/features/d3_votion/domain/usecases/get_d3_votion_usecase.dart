import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:bloc_digital_wallet/core/errors/failures.dart';
import 'package:bloc_digital_wallet/features/d3_votion/domain/entities/d3_votion_entity.dart';
import 'package:bloc_digital_wallet/features/d3_votion/domain/repositories/d3_votion_repository.dart';

@injectable
class GetD3VotionUseCase {
  final D3VotionRepository _repository;

  GetD3VotionUseCase(this._repository);

  Future<Either<Failure, D3VotionEntity>> call(String word) async {
    return _repository.getD3Votion(word);
  }
}
