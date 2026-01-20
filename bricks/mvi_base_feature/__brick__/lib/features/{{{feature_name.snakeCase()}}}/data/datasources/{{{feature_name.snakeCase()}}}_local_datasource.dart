// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when implementing
// import '../models/{{{feature_name.snakeCase()}}}_model.dart';

/// ============================================================================
/// {{feature_name.pascalCase()}} Local DataSource
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
/// abstract class {{feature_name.pascalCase()}}LocalDataSource {
///   Future<List<{{feature_name.pascalCase()}}Model>> getCached();
///   Future<void> cacheAll(List<{{feature_name.pascalCase()}}Model> models);
///   Future<void> clearCache();
/// }
/// 
/// @LazySingleton(as: {{feature_name.pascalCase()}}LocalDataSource)
/// class {{feature_name.pascalCase()}}LocalDataSourceImpl implements {{feature_name.pascalCase()}}LocalDataSource {
///   final Box<{{feature_name.pascalCase()}}Model> _box;
/// 
///   {{feature_name.pascalCase()}}LocalDataSourceImpl(this._box);
/// 
///   @override
///   Future<List<{{feature_name.pascalCase()}}Model>> getCached() async {
///     try {
///       return _box.values.toList();
///     } catch (e) {
///       throw CacheException('Failed to read cache');
///     }
///   }
/// 
///   @override
///   Future<void> cacheAll(List<{{feature_name.pascalCase()}}Model> models) async {
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

abstract class {{feature_name.pascalCase()}}LocalDataSource {
  // TODO: Define local data source methods
  // Future<List<{{feature_name.pascalCase()}}Model>> getCached();
  // Future<void> cacheAll(List<{{feature_name.pascalCase()}}Model> models);
}

@LazySingleton(as: {{feature_name.pascalCase()}}LocalDataSource)
class {{feature_name.pascalCase()}}LocalDataSourceImpl implements {{feature_name.pascalCase()}}LocalDataSource {
  // TODO: Inject storage client
  // final Box<{{feature_name.pascalCase()}}Model> _box;

  {{feature_name.pascalCase()}}LocalDataSourceImpl();
  // {{feature_name.pascalCase()}}LocalDataSourceImpl(this._box);

  // TODO: Implement datasource methods
}
