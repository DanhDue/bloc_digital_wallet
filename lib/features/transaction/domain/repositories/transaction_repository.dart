// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction_entity.dart';

abstract class TransactionRepository {
  /// Get transaction by id
  Future<Either<Failure, TransactionEntity>> getTransaction(String id);

  /// Get all transactions
  Future<Either<Failure, List<TransactionEntity>>> getAllTransactions();

  /// Create a new transaction
  Future<Either<Failure, TransactionEntity>> createTransaction(TransactionEntity entity);

  /// Update transaction
  Future<Either<Failure, TransactionEntity>> updateTransaction(TransactionEntity entity);

  /// Delete transaction
  Future<Either<Failure, void>> deleteTransaction(String id);
}
