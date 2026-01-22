// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when implementing
// import '../models/d3_votion_model.dart';

/// ============================================================================
/// D3Votion Local DataSource
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
/// abstract class D3VotionLocalDataSource {
///   Future<List<D3VotionModel>> getCached();
///   Future<void> cacheAll(List<D3VotionModel> models);
///   Future<void> clearCache();
/// }
///
/// @LazySingleton(as: D3VotionLocalDataSource)
/// class D3VotionLocalDataSourceImpl implements D3VotionLocalDataSource {
///   final Box<D3VotionModel> _box;
///
///   D3VotionLocalDataSourceImpl(this._box);
///
///   @override
///   Future<List<D3VotionModel>> getCached() async {
///     try {
///       return _box.values.toList();
///     } catch (e) {
///       throw CacheException('Failed to read cache');
///     }
///   }
///
///   @override
///   Future<void> cacheAll(List<D3VotionModel> models) async {
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

abstract class D3VotionLocalDataSource {
  // TODO: Define local data source methods
  // Future<List<D3VotionModel>> getCached();
  // Future<void> cacheAll(List<D3VotionModel> models);
}

@LazySingleton(as: D3VotionLocalDataSource)
class D3VotionLocalDataSourceImpl implements D3VotionLocalDataSource {
  // TODO: Inject storage client
  // final Box<D3VotionModel> _box;

  D3VotionLocalDataSourceImpl();
  // D3VotionLocalDataSourceImpl(this._box);

  // TODO: Implement datasource methods
}
