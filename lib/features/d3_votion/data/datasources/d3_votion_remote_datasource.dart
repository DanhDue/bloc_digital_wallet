// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when implementing
// import '../models/d3_votion_model.dart';

/// ============================================================================
/// D3Votion Remote DataSource
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
/// abstract class D3VotionRemoteDataSource {
///   Future<List<D3VotionModel>> getAll();
///   Future<D3VotionModel> getById(String id);
///   Future<D3VotionModel> create(D3VotionModel model);
/// }
///
/// @LazySingleton(as: D3VotionRemoteDataSource)
/// class D3VotionRemoteDataSourceImpl implements D3VotionRemoteDataSource {
///   final Dio _dio;
///
///   D3VotionRemoteDataSourceImpl(this._dio);
///
///   @override
///   Future<List<D3VotionModel>> getAll() async {
///     try {
///       final response = await _dio.get('/api/d3-votion');
///       return (response.data as List)
///           .map((json) => D3VotionModel.fromJson(json))
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

abstract class D3VotionRemoteDataSource {
  // TODO: Define remote data source methods
  // Future<List<D3VotionModel>> getAll();
}

@LazySingleton(as: D3VotionRemoteDataSource)
class D3VotionRemoteDataSourceImpl implements D3VotionRemoteDataSource {
  // TODO: Inject API client
  // final Dio _dio;

  D3VotionRemoteDataSourceImpl();
  // D3VotionRemoteDataSourceImpl(this._dio);

  // TODO: Implement datasource methods
}
