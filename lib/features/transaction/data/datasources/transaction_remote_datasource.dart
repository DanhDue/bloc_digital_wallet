// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when implementing
// import '../models/transaction_model.dart';

/// ============================================================================
/// Transaction Remote DataSource
/// ============================================================================
/// Remote datasources handle API calls and network requests.
/// They return data models (not entities).
///
/// HOW TO IMPLEMENT:
/// 1. Inject API client (Dio, http client)
/// 2. Implement methods for each API endpoint
/// 3. Throw ServerException on errors
/// 4. Parse JSON response to models
///
/// EXAMPLE - Full remote datasource:
/// ```dart
/// abstract class TransactionRemoteDataSource {
///   Future<List<TransactionModel>> getAll();
///   Future<TransactionModel> getById(String id);
///   Future<TransactionModel> create(TransactionModel model);
/// }
///
/// @LazySingleton(as: TransactionRemoteDataSource)
/// class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
///   final Dio _dio;
///
///   TransactionRemoteDataSourceImpl(this._dio);
///
///   @override
///   Future<List<TransactionModel>> getAll() async {
///     try {
///       final response = await _dio.get('/api/transaction');
///       return (response.data as List)
///           .map((json) => TransactionModel.fromJson(json))
///           .toList();
///     } on DioException catch (e) {
///       throw ServerException(e.message ?? 'Network error');
///     }
///   }
/// }
/// ```
///
/// BEST PRACTICES:
/// - Keep datasource focused on single data source
/// - Always throw typed exceptions (ServerException)
/// - Use interceptors for auth, logging
/// ============================================================================

abstract class TransactionRemoteDataSource {
  // TODO: Define remote data source methods
  // Future<List<TransactionModel>> getAll();
}

@LazySingleton(as: TransactionRemoteDataSource)
class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  // TODO: Inject API client
  // final Dio _dio;

  TransactionRemoteDataSourceImpl();
  // TransactionRemoteDataSourceImpl(this._dio);

  // TODO: Implement datasource methods
}
