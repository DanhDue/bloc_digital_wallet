// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when implementing
// import '../models/trends_model.dart';

/// ============================================================================
/// Trends Local DataSource
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
/// abstract class TrendsLocalDataSource {
///   Future<List<TrendsModel>> getCached();
///   Future<void> cacheAll(List<TrendsModel> models);
///   Future<void> clearCache();
/// }
///
/// @LazySingleton(as: TrendsLocalDataSource)
/// class TrendsLocalDataSourceImpl implements TrendsLocalDataSource {
///   final Box<TrendsModel> _box;
///
///   TrendsLocalDataSourceImpl(this._box);
///
///   @override
///   Future<List<TrendsModel>> getCached() async {
///     try {
///       return _box.values.toList();
///     } catch (e) {
///       throw CacheException('Failed to read cache');
///     }
///   }
///
///   @override
///   Future<void> cacheAll(List<TrendsModel> models) async {
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

abstract class TrendsLocalDataSource {
  // TODO: Define local data source methods
  // Future<List<TrendsModel>> getCached();
  // Future<void> cacheAll(List<TrendsModel> models);
}

@LazySingleton(as: TrendsLocalDataSource)
class TrendsLocalDataSourceImpl implements TrendsLocalDataSource {
  // TODO: Inject storage client
  // final Box<TrendsModel> _box;

  TrendsLocalDataSourceImpl();
  // TrendsLocalDataSourceImpl(this._box);

  // TODO: Implement datasource methods
}
