// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_local_datasource.dart';
import '../datasources/wallet_remote_datasource.dart';
import '../models/wallet_model.dart';

@LazySingleton(as: WalletRepository)
class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;
  final WalletLocalDataSource localDataSource;

  WalletRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, WalletEntity>> getWallet(String id) async {
    try {
      // Try cache first
      final cachedData = await localDataSource.getCachedWallet(id);
      if (cachedData != null) {
        return Right(cachedData.toEntity());
      }

      // Fetch from remote
      final remoteData = await remoteDataSource.getWallet(id);
      await localDataSource.cacheWallet(remoteData);

      return Right(remoteData.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WalletEntity>>> getAllWallets() async {
    try {
      final remoteData = await remoteDataSource.getAllWallets();

      // Cache all items
      for (final item in remoteData) {
        await localDataSource.cacheWallet(item);
      }

      return Right(remoteData.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      // Try cache on failure
      try {
        final cachedData = await localDataSource.getAllCachedWallets();
        return Right(cachedData.map((model) => model.toEntity()).toList());
      } catch (_) {
        return Left(ServerFailure(message: e.message, code: e.code));
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, WalletEntity>> createWallet(WalletEntity entity) async {
    try {
      final model = WalletModel.fromEntity(entity);
      final result = await remoteDataSource.createWallet(model);
      await localDataSource.cacheWallet(result);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, WalletEntity>> updateWallet(WalletEntity entity) async {
    try {
      final model = WalletModel.fromEntity(entity);
      final result = await remoteDataSource.updateWallet(model);
      await localDataSource.cacheWallet(result);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteWallet(String id) async {
    try {
      await remoteDataSource.deleteWallet(id);
      await localDataSource.clearCache();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
