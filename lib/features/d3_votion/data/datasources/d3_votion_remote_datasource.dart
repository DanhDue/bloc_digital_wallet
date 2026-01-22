import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bloc_digital_wallet/features/d3_votion/domain/entities/d3_votion_entity.dart';
import 'package:bloc_digital_wallet/features/d3_votion/data/datasources/remote/d3_votion_api.dart';
import 'package:bloc_digital_wallet/core/mixin/safe_call_api_mixin.dart';
import 'package:bloc_digital_wallet/core/errors/failures.dart';

abstract class D3VotionRemoteDataSource {
  Future<Either<Failure, D3VotionEntity>> getD3Votion(String word);
}

@LazySingleton(as: D3VotionRemoteDataSource)
class D3VotionRemoteDataSourceImpl with SafeCallApiMixin implements D3VotionRemoteDataSource {
  final D3VotionApi _api;

  D3VotionRemoteDataSourceImpl(this._api);

  @override
  Future<Either<Failure, D3VotionEntity>> getD3Votion(String word) {
    return safeApiCall(
      () => _api.getD3Votion(word),
    );
  }
}
