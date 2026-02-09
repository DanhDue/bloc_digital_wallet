// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:transaction/domain/entities/transaction_entity.dart';
import 'package:transaction/domain/repositories/transaction_repository.dart';

@injectable
class GetTransactionsByOwnerUseCase {
  final TransactionRepository _repository;

  GetTransactionsByOwnerUseCase(this._repository);

  Future<Either<Failure, List<TransactionEntity>>> call(
    String owner, {
    int? limit,
    String? before,
    String? until,
  }) {
    return _repository.getTransactionByOwner(owner, limit: limit, before: before, until: until);
  }
}
