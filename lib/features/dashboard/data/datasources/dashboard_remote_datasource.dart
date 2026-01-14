// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
import '../models/dashboard_model.dart';

/// ============================================================================
/// Dashboard Remote DataSource
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
/// abstract class DashboardRemoteDataSource {
///   Future<List<DashboardModel>> getAll();
///   Future<DashboardModel> getById(String id);
///   Future<DashboardModel> create(DashboardModel model);
/// }
///
/// @LazySingleton(as: DashboardRemoteDataSource)
/// class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
///   final Dio _dio;
///
///   DashboardRemoteDataSourceImpl(this._dio);
///
///   @override
///   Future<List<DashboardModel>> getAll() async {
///     try {
///       final response = await _dio.get('/api/dashboard');
///       return (response.data as List)
///           .map((json) => DashboardModel.fromJson(json))
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

abstract class DashboardRemoteDataSource {
  // TODO: Define remote data source methods
  // Future<List<DashboardModel>> getAll();
}

@LazySingleton(as: DashboardRemoteDataSource)
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  // TODO: Inject API client
  // final Dio _dio;

  DashboardRemoteDataSourceImpl();
  // DashboardRemoteDataSourceImpl(this._dio);

  // TODO: Implement datasource methods
}
