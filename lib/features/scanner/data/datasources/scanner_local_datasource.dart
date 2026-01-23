// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when implementing
// import '../models/scanner_model.dart';

/// ============================================================================
/// Scanner Local DataSource
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
/// abstract class ScannerLocalDataSource {
///   Future<List<ScannerModel>> getCached();
///   Future<void> cacheAll(List<ScannerModel> models);
///   Future<void> clearCache();
/// }
///
/// @LazySingleton(as: ScannerLocalDataSource)
/// class ScannerLocalDataSourceImpl implements ScannerLocalDataSource {
///   final Box<ScannerModel> _box;
///
///   ScannerLocalDataSourceImpl(this._box);
///
///   @override
///   Future<List<ScannerModel>> getCached() async {
///     try {
///       return _box.values.toList();
///     } catch (e) {
///       throw CacheException('Failed to read cache');
///     }
///   }
///
///   @override
///   Future<void> cacheAll(List<ScannerModel> models) async {
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

abstract class ScannerLocalDataSource {
  // TODO: Define local data source methods
  // Future<List<ScannerModel>> getCached();
  // Future<void> cacheAll(List<ScannerModel> models);
}

@LazySingleton(as: ScannerLocalDataSource)
class ScannerLocalDataSourceImpl implements ScannerLocalDataSource {
  // TODO: Inject storage client
  // final Box<ScannerModel> _box;

  ScannerLocalDataSourceImpl();
  // ScannerLocalDataSourceImpl(this._box);

  // TODO: Implement datasource methods
}
