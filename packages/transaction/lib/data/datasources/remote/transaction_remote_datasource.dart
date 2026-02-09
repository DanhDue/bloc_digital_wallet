// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:framework/framework.dart';
import 'package:injectable/injectable.dart';
import 'package:transaction/data/datasources/remote/transaction_client.dart';
import 'package:transaction/data/models/transaction_model.dart';
import 'package:transaction/domain/entities/transaction_entity.dart';

@lazySingleton
class TransactionRemoteDataSource with SafeCallApiMixin {
  final TransactionClient _client;

  TransactionRemoteDataSource(this._client);

  Future<Either<Failure, TransactionEntity>> getTransaction() async {
    final result = await safeApiCall(() => _client.getTransaction());
    return result.map((model) => model.toEntity());
  }
}
