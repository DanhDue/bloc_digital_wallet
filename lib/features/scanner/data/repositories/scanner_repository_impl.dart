// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/scanner_entity.dart';
import '../../domain/repositories/scanner_repository.dart';
import '../datasources/scanner_local_datasource.dart';
import '../datasources/scanner_remote_datasource.dart';
import '../models/scanner_model.dart';

@LazySingleton(as: ScannerRepository)
class ScannerRepositoryImpl implements ScannerRepository {
  final ScannerRemoteDataSource remoteDataSource;
  final ScannerLocalDataSource localDataSource;

  ScannerRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, ScannerEntity>> getScanner(String id) async {
    try {
      // Try cache first
      final cachedData = await localDataSource.getCachedScanner(id);
      if (cachedData != null) {
        return Right(cachedData.toEntity());
      }

      // Fetch from remote
      final remoteData = await remoteDataSource.getScanner(id);
      await localDataSource.cacheScanner(remoteData);

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
  Future<Either<Failure, List<ScannerEntity>>> getAllScanners() async {
    try {
      final remoteData = await remoteDataSource.getAllScanners();

      // Cache all items
      for (final item in remoteData) {
        await localDataSource.cacheScanner(item);
      }

      return Right(remoteData.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      // Try cache on failure
      try {
        final cachedData = await localDataSource.getAllCachedScanners();
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
  Future<Either<Failure, ScannerEntity>> createScanner(ScannerEntity entity) async {
    try {
      final model = ScannerModel.fromEntity(entity);
      final result = await remoteDataSource.createScanner(model);
      await localDataSource.cacheScanner(result);
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
  Future<Either<Failure, ScannerEntity>> updateScanner(ScannerEntity entity) async {
    try {
      final model = ScannerModel.fromEntity(entity);
      final result = await remoteDataSource.updateScanner(model);
      await localDataSource.cacheScanner(result);
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
  Future<Either<Failure, void>> deleteScanner(String id) async {
    try {
      await remoteDataSource.deleteScanner(id);
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
