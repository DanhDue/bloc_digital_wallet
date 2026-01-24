import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:bloc_digital_wallet/core/errors/failures.dart';
import 'package:bloc_digital_wallet/core/mixin/safe_call_api_mixin.dart';
import 'package:bloc_digital_wallet/features/d3_votion/data/models/d3_votion_res_object.dart';
import 'package:bloc_digital_wallet/features/d3_votion/data/datasources/remote/d3_votion_client.dart';

abstract class D3VotionRemoteDataSource {
  Future<Either<Failure, D3VotionResObject>> getD3Votion(String word);
}

@LazySingleton(as: D3VotionRemoteDataSource)
class D3VotionRemoteDataSourceImpl with SafeCallApiMixin implements D3VotionRemoteDataSource {
  final D3VotionClient _client;

  D3VotionRemoteDataSourceImpl(this._client);

  @override
  Future<Either<Failure, D3VotionResObject>> getD3Votion(String word) async {
    return safeApiCall(() => _client.getD3Votion(word));
  }
}
