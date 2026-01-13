// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/trends_entity.dart';
import '../../domain/repositories/trends_repository.dart';
import '../datasources/trends_local_datasource.dart';
import '../datasources/trends_remote_datasource.dart';
import '../models/trends_model.dart';

@LazySingleton(as: TrendsRepository)
class TrendsRepositoryImpl implements TrendsRepository {
  final TrendsRemoteDataSource remoteDataSource;
  final TrendsLocalDataSource localDataSource;

  TrendsRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, TrendsEntity>> getTrends(String id) async {
    try {
      // Try cache first
      final cachedData = await localDataSource.getCachedTrends(id);
      if (cachedData != null) {
        return Right(cachedData.toEntity());
      }

      // Fetch from remote
      final remoteData = await remoteDataSource.getTrends(id);
      await localDataSource.cacheTrends(remoteData);

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
  Future<Either<Failure, List<TrendsEntity>>> getAllTrendss() async {
    try {
      final remoteData = await remoteDataSource.getAllTrendss();

      // Cache all items
      for (final item in remoteData) {
        await localDataSource.cacheTrends(item);
      }

      return Right(remoteData.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      // Try cache on failure
      try {
        final cachedData = await localDataSource.getAllCachedTrendss();
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
  Future<Either<Failure, TrendsEntity>> createTrends(TrendsEntity entity) async {
    try {
      final model = TrendsModel.fromEntity(entity);
      final result = await remoteDataSource.createTrends(model);
      await localDataSource.cacheTrends(result);
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
  Future<Either<Failure, TrendsEntity>> updateTrends(TrendsEntity entity) async {
    try {
      final model = TrendsModel.fromEntity(entity);
      final result = await remoteDataSource.updateTrends(model);
      await localDataSource.cacheTrends(result);
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
  Future<Either<Failure, void>> deleteTrends(String id) async {
    try {
      await remoteDataSource.deleteTrends(id);
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
