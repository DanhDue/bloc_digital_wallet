// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:transaction/domain/entities/transaction_entity.dart';
import 'package:transaction/domain/repositories/transaction_repository.dart';

@injectable
class GetTransactionUseCase {
  final TransactionRepository _repository;

  GetTransactionUseCase(this._repository);

  Future<Either<Failure, TransactionEntity>> call() {
    return _repository.getTransaction();
  }
}
