// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:transaction/data/datasources/remote/transaction_remote_datasource.dart';
import 'package:transaction/domain/entities/transaction_entity.dart';
import 'package:transaction/domain/repositories/transaction_repository.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource _remoteDataSource;

  TransactionRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, TransactionEntity>> getTransaction() {
    return _remoteDataSource.getTransaction();
  }
}
