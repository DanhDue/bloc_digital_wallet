// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:transaction/domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<Either<Failure, TransactionEntity?>> getTransactionBySignature(
    String signature, {
    bool? parsedJson,
    List<String>? owners,
  });

  Future<Either<Failure, List<TransactionEntity>>> getTransactionByOwner(
    String owner, {
    int? limit,
    String? before,
    String? until,
  });
}
