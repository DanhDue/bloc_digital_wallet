// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';

/// ============================================================================
/// Dashboard Local DataSource
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
/// abstract class DashboardLocalDataSource {
///   Future<List<DashboardModel>> getCached();
///   Future<void> cacheAll(List<DashboardModel> models);
///   Future<void> clearCache();
/// }
///
/// @LazySingleton(as: DashboardLocalDataSource)
/// class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
///   final Box<DashboardModel> _box;
///
///   DashboardLocalDataSourceImpl(this._box);
///
///   @override
///   Future<List<DashboardModel>> getCached() async {
///     try {
///       return _box.values.toList();
///     } catch (e) {
///       throw CacheException('Failed to read cache');
///     }
///   }
///
///   @override
///   Future<void> cacheAll(List<DashboardModel> models) async {
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

abstract class DashboardLocalDataSource {
  // TODO: Define local data source methods
  // Future<List<DashboardModel>> getCached();
  // Future<void> cacheAll(List<DashboardModel> models);
}

@LazySingleton(as: DashboardLocalDataSource)
class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  // TODO: Inject storage client
  // final Box<DashboardModel> _box;

  DashboardLocalDataSourceImpl();
  // DashboardLocalDataSourceImpl(this._box);

  // TODO: Implement datasource methods
}
