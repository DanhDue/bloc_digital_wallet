// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:bloc_digital_wallet/core/errors/failures.dart';
import 'package:bloc_digital_wallet/core/mixin/safe_call_api_mixin.dart';
import 'package:bloc_digital_wallet/features/d3_votion/data/datasources/remote/d3_votion_client.dart';
import 'package:bloc_digital_wallet/features/d3_votion/data/models/d3_votion_res_object.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class D3VotionRemoteDataSource with SafeCallApiMixin {
  final D3VotionClient _client;

  D3VotionRemoteDataSource(this._client);

  Future<Either<Failure, D3VotionResObject>> getD3Votion({required String word}) =>
      safeApiCall(() => _client.getD3Votion(word));
}
