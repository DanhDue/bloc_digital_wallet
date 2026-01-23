// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when implementing
// import '../models/transaction_model.dart';

/// ============================================================================
/// Transaction Local DataSource
/// ============================================================================
/// Local datasources handle local storage (cache, database).
/// They return data models (not entities).
///
/// HOW TO IMPLEMENT:
/// 1. Inject storage client (Hive, SharedPreferences, SQLite)
/// 2. Implement methods for CRUD operations
/// 3. Throw CacheException on errors
///
/// EXAMPLE - Hive-based local datasource:
/// ```dart
/// abstract class TransactionLocalDataSource {
///   Future<List<TransactionModel>> getCached();
///   Future<void> cacheAll(List<TransactionModel> models);
///   Future<void> clearCache();
/// }
///
/// @LazySingleton(as: TransactionLocalDataSource)
/// class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
///   final Box<TransactionModel> _box;
///
///   TransactionLocalDataSourceImpl(this._box);
///
///   @override
///   Future<List<TransactionModel>> getCached() async {
///     try {
///       return _box.values.toList();
///     } catch (e) {
///       throw CacheException('Failed to read cache');
///     }
///   }
///
///   @override
///   Future<void> cacheAll(List<TransactionModel> models) async {
///     await _box.clear();
///     await _box.addAll(models);
///   }
/// }
/// ```
///
/// STORAGE OPTIONS:
/// - Hive: Fast, lightweight, NoSQL
/// - SharedPreferences: Simple key-value (small data)
/// - SQLite/Drift: Relational data, complex queries
/// - SecureStorage: Sensitive data (tokens, credentials)
/// ============================================================================

abstract class TransactionLocalDataSource {
  // TODO: Define local data source methods
  // Future<List<TransactionModel>> getCached();
  // Future<void> cacheAll(List<TransactionModel> models);
}

@LazySingleton(as: TransactionLocalDataSource)
class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  // TODO: Inject storage client
  // final Box<TransactionModel> _box;

  TransactionLocalDataSourceImpl();
  // TransactionLocalDataSourceImpl(this._box);

  // TODO: Implement datasource methods
}
