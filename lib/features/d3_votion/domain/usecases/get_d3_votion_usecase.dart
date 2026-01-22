// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:bloc_digital_wallet/core/errors/failures.dart';
import '../entities/d3_votion_entity.dart';
import '../repositories/d3_votion_repository.dart';

@injectable
class GetD3VotionUseCase {
  final D3VotionRepository _repository;

  GetD3VotionUseCase(this._repository);

  Future<Either<Failure, D3VotionEntity>> call(String word) async {
    return _repository.getD3Votion(word);
  }
}
