// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when implementing
// import '../models/{{{feature_name.snakeCase()}}}_model.dart';

/// ============================================================================
/// {{feature_name.pascalCase()}} Remote DataSource
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
/// abstract class {{feature_name.pascalCase()}}RemoteDataSource {
///   Future<List<{{feature_name.pascalCase()}}Model>> getAll();
///   Future<{{feature_name.pascalCase()}}Model> getById(String id);
///   Future<{{feature_name.pascalCase()}}Model> create({{feature_name.pascalCase()}}Model model);
/// }
/// 
/// @LazySingleton(as: {{feature_name.pascalCase()}}RemoteDataSource)
/// class {{feature_name.pascalCase()}}RemoteDataSourceImpl implements {{feature_name.pascalCase()}}RemoteDataSource {
///   final Dio _dio;
/// 
///   {{feature_name.pascalCase()}}RemoteDataSourceImpl(this._dio);
/// 
///   @override
///   Future<List<{{feature_name.pascalCase()}}Model>> getAll() async {
///     try {
///       final response = await _dio.get('/api/{{feature_name.paramCase()}}');
///       return (response.data as List)
///           .map((json) => {{feature_name.pascalCase()}}Model.fromJson(json))
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

abstract class {{feature_name.pascalCase()}}RemoteDataSource {
  // TODO: Define remote data source methods
  // Future<List<{{feature_name.pascalCase()}}Model>> getAll();
}

@LazySingleton(as: {{feature_name.pascalCase()}}RemoteDataSource)
class {{feature_name.pascalCase()}}RemoteDataSourceImpl implements {{feature_name.pascalCase()}}RemoteDataSource {
  // TODO: Inject API client
  // final Dio _dio;

  {{feature_name.pascalCase()}}RemoteDataSourceImpl();
  // {{feature_name.pascalCase()}}RemoteDataSourceImpl(this._dio);

  // TODO: Implement datasource methods
}
