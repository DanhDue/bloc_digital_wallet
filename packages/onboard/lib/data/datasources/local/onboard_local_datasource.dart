// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when implementing
// import '../models/onboard_model.dart';

/// ============================================================================
/// Onboard Local DataSource
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
/// abstract class OnboardLocalDataSource {
///   Future<List<OnboardModel>> getCached();
///   Future<void> cacheAll(List<OnboardModel> models);
///   Future<void> clearCache();
/// }
///
/// @LazySingleton(as: OnboardLocalDataSource)
/// class OnboardLocalDataSourceImpl implements OnboardLocalDataSource {
///   final Box<OnboardModel> _box;
///
///   OnboardLocalDataSourceImpl(this._box);
///
///   @override
///   Future<List<OnboardModel>> getCached() async {
///     try {
///       return _box.values.toList();
///     } catch (e) {
///       throw CacheException('Failed to read cache');
///     }
///   }
///
///   @override
///   Future<void> cacheAll(List<OnboardModel> models) async {
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

abstract class OnboardLocalDataSource {
  // TODO: Define local data source methods
  // Future<List<OnboardModel>> getCached();
  // Future<void> cacheAll(List<OnboardModel> models);
}

@LazySingleton(as: OnboardLocalDataSource)
class OnboardLocalDataSourceImpl implements OnboardLocalDataSource {
  // TODO: Inject storage client
  // final Box<OnboardModel> _box;

  OnboardLocalDataSourceImpl();
  // OnboardLocalDataSourceImpl(this._box);

  // TODO: Implement datasource methods
}
