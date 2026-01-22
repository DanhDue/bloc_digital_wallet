import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:bloc_digital_wallet/core/errors/failures.dart';
import '../../domain/entities/d3_votion_entity.dart';
import '../../domain/repositories/d3_votion_repository.dart';
import '../datasources/d3_votion_remote_datasource.dart';

@LazySingleton(as: D3VotionRepository)
class D3VotionRepositoryImpl implements D3VotionRepository {
  final D3VotionRemoteDataSource _remoteDataSource;

  D3VotionRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, D3VotionEntity>> getD3Votion(String word) {
    return _remoteDataSource.getD3Votion(word);
  }
}
