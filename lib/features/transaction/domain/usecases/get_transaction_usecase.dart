// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

@injectable
class GetTransactionUseCase {
  final TransactionRepository repository;

  GetTransactionUseCase(this.repository);

  Future<Either<Failure, TransactionEntity>> call(String id) async {
    return await repository.getTransaction(id);
  }
}
