// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when implementing
// import '../models/trends_model.dart';

/// ============================================================================
/// Trends Remote DataSource
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
/// abstract class TrendsRemoteDataSource {
///   Future<List<TrendsModel>> getAll();
///   Future<TrendsModel> getById(String id);
///   Future<TrendsModel> create(TrendsModel model);
/// }
///
/// @LazySingleton(as: TrendsRemoteDataSource)
/// class TrendsRemoteDataSourceImpl implements TrendsRemoteDataSource {
///   final Dio _dio;
///
///   TrendsRemoteDataSourceImpl(this._dio);
///
///   @override
///   Future<List<TrendsModel>> getAll() async {
///     try {
///       final response = await _dio.get('/api/trends');
///       return (response.data as List)
///           .map((json) => TrendsModel.fromJson(json))
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

abstract class TrendsRemoteDataSource {
  // TODO: Define remote data source methods
  // Future<List<TrendsModel>> getAll();
}

@LazySingleton(as: TrendsRemoteDataSource)
class TrendsRemoteDataSourceImpl implements TrendsRemoteDataSource {
  // TODO: Inject API client
  // final Dio _dio;

  TrendsRemoteDataSourceImpl();
  // TrendsRemoteDataSourceImpl(this._dio);

  // TODO: Implement datasource methods
}
