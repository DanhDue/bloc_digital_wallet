import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/d3_votion_entity.dart';

abstract class D3VotionRepository {
  Future<Either<Failure, D3VotionEntity>> getD3Votion(String word);
}
