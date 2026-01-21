// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_digital_wallet/core/mixin/safe_call_api_mixin.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:bloc_digital_wallet/core/errors/failures.dart';
import 'package:bloc_digital_wallet/core/network/base_response_object.dart';
import 'package:bloc_digital_wallet/features/wallet/data/models/token_account_object.dart';
import 'package:bloc_digital_wallet/features/wallet/data/datasources/remote/token_client.dart';

/// ============================================================================
/// Wallet Remote DataSource
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
/// abstract class WalletRemoteDataSource {
///   Future<List<WalletModel>> getAll();
///   Future<WalletModel> getById(String id);
///   Future<WalletModel> create(WalletModel model);
/// }
///
/// @LazySingleton(as: WalletRemoteDataSource)
/// class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
///   final Dio _dio;
///
///   WalletRemoteDataSourceImpl(this._dio);
///
///   @override
///   Future<List<WalletModel>> getAll() async {
///     try {
///       final response = await _dio.get('/api/wallet');
///       return (response.data as List)
///           .map((json) => WalletModel.fromJson(json))
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

abstract class WalletRemoteDataSource {
  Future<Either<Failure, BaseResponseObject<List<TokenAccountObject>>>> getTokenAccounts(
    String address,
  );
}

@LazySingleton(as: WalletRemoteDataSource)
class WalletRemoteDataSourceImpl with SafeCallApiMixin implements WalletRemoteDataSource {
  final TokenClient _client;

  WalletRemoteDataSourceImpl(this._client);

  @override
  Future<Either<Failure, BaseResponseObject<List<TokenAccountObject>>>> getTokenAccounts(
    String address,
  ) => safeApiCall(() => _client.getTokenAccounts(address));
}
