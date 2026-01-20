// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:bloc_digital_wallet/core/errors/failures.dart';
import 'package:bloc_digital_wallet/core/mixin/safe_call_api_mixin.dart';
import 'package:bloc_digital_wallet/core/network/base_response_object.dart';
import 'package:bloc_digital_wallet/features/onboard/data/models/base_url_object.dart';
import 'health_check_client.dart';

/// ============================================================================
/// Onboard Remote DataSource
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
/// abstract class OnboardRemoteDataSource {
///   Future<List<OnboardModel>> getAll();
///   Future<OnboardModel> getById(String id);
///   Future<OnboardModel> create(OnboardModel model);
/// }
///
/// @LazySingleton(as: OnboardRemoteDataSource)
/// class OnboardRemoteDataSourceImpl implements OnboardRemoteDataSource {
///   final Dio _dio;
///
///   OnboardRemoteDataSourceImpl(this._dio);
///
///   @override
///   Future<List<OnboardModel>> getAll() async {
///     try {
///       final response = await _dio.get('/api/onboard');
///       return (response.data as List)
///           .map((json) => OnboardModel.fromJson(json))
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

abstract class OnboardRemoteDataSource {
  Future<Either<Failure, BaseResponseObject<dynamic>>> healthCheck();
  Future<Either<Failure, BaseResponseObject<List<BaseUrlObject>>>> getBaseUrl();
}

@LazySingleton(as: OnboardRemoteDataSource)
class OnboardRemoteDataSourceImpl with SafeCallApiMixin implements OnboardRemoteDataSource {
  final HealthCheckClient _healthCheckClient;

  OnboardRemoteDataSourceImpl(this._healthCheckClient);

  @override
  Future<Either<Failure, BaseResponseObject<dynamic>>> healthCheck() =>
      safeApiCall(() => _healthCheckClient.healthCheck());

  @override
  Future<Either<Failure, BaseResponseObject<List<BaseUrlObject>>>> getBaseUrl() =>
      safeApiCall(() => _healthCheckClient.getBaseUrl());
}
