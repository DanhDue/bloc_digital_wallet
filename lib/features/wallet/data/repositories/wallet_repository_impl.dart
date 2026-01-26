// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment imports when implementing
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_local_datasource.dart';
import '../datasources/wallet_remote_datasource.dart';
import '../../domain/entities/token_account_entity.dart';

/// ============================================================================
/// Wallet Repository Implementation
/// ============================================================================
/// Repository implementations handle data source orchestration and error handling.
/// They implement the domain repository interface.
///
/// HOW TO IMPLEMENT:
/// 1. Inject datasources via constructor
/// 2. Implement all methods from the interface
/// 3. Handle exceptions and convert to Failure types
/// 4. Implement caching strategy if needed
///
/// EXAMPLE - Full repository implementation:
/// ```dart
/// @LazySingleton(as: WalletRepository)
/// class WalletRepositoryImpl implements WalletRepository {
///   final WalletRemoteDataSource _remoteDataSource;
///   final WalletLocalDataSource _localDataSource;
///
///   WalletRepositoryImpl(
///     this._remoteDataSource,
///     this._localDataSource,
///   );
///
///   @override
///   Future<Either<Failure, List<WalletEntity>>> getAll() async {
///     try {
///       // Try remote first
///       final models = await _remoteDataSource.getAll();
///       final entities = models.map((m) => m.toEntity()).toList();
///
///       // Cache locally
///       await _localDataSource.cacheAll(models);
///
///       return Right(entities);
///     } on ServerException catch (e) {
///       // Fallback to cache on network error
///       try {
///         final cached = await _localDataSource.getCached();
///         return Right(cached.map((m) => m.toEntity()).toList());
///       } catch (_) {
///         return Left(ServerFailure(e.message));
///       }
///     }
///   }
/// }
/// ```
///
/// ERROR HANDLING PATTERNS:
/// - ServerException → ServerFailure
/// - CacheException → CacheFailure
/// - NetworkException → NetworkFailure
/// ============================================================================

@LazySingleton(as: WalletRepository)
class WalletRepositoryImpl implements WalletRepository {
  final WalletLocalDataSource _localDataSource;
  final WalletRemoteDataSource _remoteDataSource;

  WalletRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<Either<Failure, List<WalletEntity>>> getWallets() async {
    try {
      final models = await _localDataSource.getWallets();
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TokenAccountEntity>>> getTokenAccounts(String address) async {
    final result = await _remoteDataSource.getTokenAccounts(address: address);
    return result.fold((failure) => Left(failure), (response) {
      if (response.data == null) return const Right([]);
      return Right(response.data!.map((e) => e.toEntity()).toList());
    });
  }
}
