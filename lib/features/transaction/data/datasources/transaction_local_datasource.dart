// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:injectable/injectable.dart';
import '../models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<void> cacheTransaction(TransactionModel model);
  Future<TransactionModel?> getCachedTransaction(String id);
  Future<List<TransactionModel>> getAllCachedTransactions();
  Future<void> clearCache();
}

@LazySingleton(as: TransactionLocalDataSource)
class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  // TODO: Inject Hive, SharedPreferences, or SecureStorage
  // final Box<TransactionModel> box;

  // const TransactionLocalDataSourceImpl(this.box);

  @override
  Future<void> cacheTransaction(TransactionModel model) async {
    // TODO: Implement caching
    throw UnimplementedError();
  }

  @override
  Future<TransactionModel?> getCachedTransaction(String id) async {
    // TODO: Implement cache retrieval
    throw UnimplementedError();
  }

  @override
  Future<List<TransactionModel>> getAllCachedTransactions() async {
    // TODO: Implement cache retrieval
    throw UnimplementedError();
  }

  @override
  Future<void> clearCache() async {
    // TODO: Implement cache clearing
    throw UnimplementedError();
  }
}
