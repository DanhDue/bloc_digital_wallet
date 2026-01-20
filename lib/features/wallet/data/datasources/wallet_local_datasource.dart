// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when implementing
// import '../models/wallet_model.dart';

/// ============================================================================
/// Wallet Local DataSource
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
/// abstract class WalletLocalDataSource {
///   Future<List<WalletModel>> getCached();
///   Future<void> cacheAll(List<WalletModel> models);
///   Future<void> clearCache();
/// }
///
/// @LazySingleton(as: WalletLocalDataSource)
/// class WalletLocalDataSourceImpl implements WalletLocalDataSource {
///   final Box<WalletModel> _box;
///
///   WalletLocalDataSourceImpl(this._box);
///
///   @override
///   Future<List<WalletModel>> getCached() async {
///     try {
///       return _box.values.toList();
///     } catch (e) {
///       throw CacheException('Failed to read cache');
///     }
///   }
///
///   @override
///   Future<void> cacheAll(List<WalletModel> models) async {
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

abstract class WalletLocalDataSource {
  // TODO: Define local data source methods
  // Future<List<WalletModel>> getCached();
  // Future<void> cacheAll(List<WalletModel> models);
}

@LazySingleton(as: WalletLocalDataSource)
class WalletLocalDataSourceImpl implements WalletLocalDataSource {
  // TODO: Inject storage client
  // final Box<WalletModel> _box;

  WalletLocalDataSourceImpl();
  // WalletLocalDataSourceImpl(this._box);

  // TODO: Implement datasource methods
}
