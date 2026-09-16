// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:transaction/data/datasources/remote/transaction_client.dart';
import 'package:transaction/domain/entities/transaction_entity.dart';
import 'package:framework/framework.dart';

@lazySingleton
class TransactionRemoteDataSource with SafeCallApiMixin {
  final TransactionClient _client;

  TransactionRemoteDataSource(this._client);

  Future<Either<Failure, List<TransactionEntity>>> getTransactionByOwner(
    String owner, {
    int? limit,
    String? before,
    String? until,
  }) async {
    final result = await safeApiCall(
      () => _client.getTransactionByOwner(owner, limit, before, until),
    );
    return result.map(
      (response) =>
          response?.data?.map((e) => e?.toEntity()).whereType<TransactionEntity>().toList() ?? [],
    );
  }

  Future<Either<Failure, TransactionEntity?>> getTransactionBySignature(
    String signature, {
    bool? parsedJson,
    List<String>? owners,
  }) async {
    final result = await safeApiCall(
      () => _client.getTransactionBySignature(signature, parsedJson, owners),
    );
    return result.map((response) => response?.data?.toEntity());
  }
}
