import 'package:bloc_digital_wallet/core/errors/failures.dart';
import 'package:bloc_digital_wallet/features/d3_votion/data/models/d3_votion_res_object.dart';
import 'package:dartz/dartz.dart';

abstract class D3VotionRepository {
  Future<Either<Failure, D3VotionResObject>> getD3Votion(String word);
}
