// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:framework/framework.dart';
import 'package:injectable/injectable.dart';
import 'package:trends/data/datasources/remote/trends_client.dart';
import 'package:trends/domain/entities/trends_entity.dart';

@lazySingleton
class TrendsRemoteDataSource with SafeCallApiMixin {
  final TrendsClient _client;

  TrendsRemoteDataSource(this._client);

  Future<Either<Failure, TrendsEntity>> getTrends() async {
    final result = await safeApiCall(() => _client.getTrends());
    return result.map((model) => model.toEntity());
  }
}
