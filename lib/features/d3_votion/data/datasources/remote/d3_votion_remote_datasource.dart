import 'package:bloc_digital_wallet/core/mixin/safe_call_api_mixin.dart';
import 'package:bloc_digital_wallet/features/d3_votion/data/datasources/remote/d3_votion_client.dart';
import 'package:bloc_digital_wallet/features/d3_votion/data/models/d3_votion_res_object.dart';
import 'package:bloc_digital_wallet/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class D3VotionRemoteDataSource with SafeCallApiMixin {
  final D3VotionClient _client;

  D3VotionRemoteDataSource(this._client);

  Future<Either<Failure, D3VotionResObject>> getD3Votion(String word) =>
      safeApiCall(() => _client.getD3Votion(word));
}
