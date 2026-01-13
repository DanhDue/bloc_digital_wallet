// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

@injectable
class GetAllTransactionsUseCase {
  final TransactionRepository repository;

  GetAllTransactionsUseCase(this.repository);

  Future<Either<Failure, List<TransactionEntity>>> call() async {
    return await repository.getAllTransactions();
  }
}
