// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:injectable/injectable.dart';
import '../models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<TransactionModel> getTransaction(String id);
  Future<List<TransactionModel>> getAllTransactions();
  Future<TransactionModel> createTransaction(TransactionModel model);
  Future<TransactionModel> updateTransaction(TransactionModel model);
  Future<void> deleteTransaction(String id);
}

@LazySingleton(as: TransactionRemoteDataSource)
class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  // TODO: Inject Dio or Retrofit API client
  // final TransactionApiClient apiClient;

  // const TransactionRemoteDataSourceImpl(this.apiClient);

  @override
  Future<TransactionModel> getTransaction(String id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<TransactionModel> createTransaction(TransactionModel model) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<TransactionModel> updateTransaction(TransactionModel model) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }
}
