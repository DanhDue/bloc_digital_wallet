// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:injectable/injectable.dart';
import 'package:bloc_digital_wallet/features/d3_votion/domain/entities/d3_votion_entity.dart';
import 'package:bloc_digital_wallet/features/d3_votion/data/datasources/remote/d3_votion_client.dart';
import 'package:bloc_digital_wallet/core/mixin/safe_call_api_mixin.dart';
import 'package:bloc_digital_wallet/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class D3VotionRemoteDataSource {
  Future<Either<Failure, D3VotionEntity>> getD3Votion(String word);
}

@LazySingleton(as: D3VotionRemoteDataSource)
class D3VotionRemoteDataSourceImpl with SafeCallApiMixin implements D3VotionRemoteDataSource {
  final D3VotionClient _client;

  D3VotionRemoteDataSourceImpl(this._client);

  @override
  Future<Either<Failure, D3VotionEntity>> getD3Votion(String word) =>
      safeApiCall(() => _client.getD3Votion(word));
}
