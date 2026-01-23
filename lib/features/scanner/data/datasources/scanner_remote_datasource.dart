// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when implementing
// import '../models/scanner_model.dart';

/// ============================================================================
/// Scanner Remote DataSource
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
/// abstract class ScannerRemoteDataSource {
///   Future<List<ScannerModel>> getAll();
///   Future<ScannerModel> getById(String id);
///   Future<ScannerModel> create(ScannerModel model);
/// }
///
/// @LazySingleton(as: ScannerRemoteDataSource)
/// class ScannerRemoteDataSourceImpl implements ScannerRemoteDataSource {
///   final Dio _dio;
///
///   ScannerRemoteDataSourceImpl(this._dio);
///
///   @override
///   Future<List<ScannerModel>> getAll() async {
///     try {
///       final response = await _dio.get('/api/scanner');
///       return (response.data as List)
///           .map((json) => ScannerModel.fromJson(json))
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

abstract class ScannerRemoteDataSource {
  // TODO: Define remote data source methods
  // Future<List<ScannerModel>> getAll();
}

@LazySingleton(as: ScannerRemoteDataSource)
class ScannerRemoteDataSourceImpl implements ScannerRemoteDataSource {
  // TODO: Inject API client
  // final Dio _dio;

  ScannerRemoteDataSourceImpl();
  // ScannerRemoteDataSourceImpl(this._dio);

  // TODO: Implement datasource methods
}
