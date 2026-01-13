// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/sample_entity.dart';
import '../../domain/repositories/sample_repository.dart';
import '../datasources/sample_local_datasource.dart';
import '../datasources/sample_remote_datasource.dart';
import '../models/sample_model.dart';

@LazySingleton(as: SampleRepository)
class SampleRepositoryImpl implements SampleRepository {
  final SampleRemoteDataSource remoteDataSource;
  final SampleLocalDataSource localDataSource;

  SampleRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, SampleEntity>> getSample(String id) async {
    try {
      // Try cache first
      final cachedData = await localDataSource.getCachedSample(id);
      if (cachedData != null) {
        return Right(cachedData.toEntity());
      }

      // Fetch from remote
      final remoteData = await remoteDataSource.getSample(id);
      await localDataSource.cacheSample(remoteData);
      
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
  Future<Either<Failure, List<SampleEntity>>> getAllSamples() async {
    try {
      final remoteData = await remoteDataSource.getAllSamples();
      
      // Cache all items
      for (final item in remoteData) {
        await localDataSource.cacheSample(item);
      }
      
      return Right(remoteData.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      // Try cache on failure
      try {
        final cachedData = await localDataSource.getAllCachedSamples();
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
  Future<Either<Failure, SampleEntity>> createSample(
      SampleEntity entity) async {
    try {
      final model = SampleModel.fromEntity(entity);
      final result = await remoteDataSource.createSample(model);
      await localDataSource.cacheSample(result);
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
  Future<Either<Failure, SampleEntity>> updateSample(
      SampleEntity entity) async {
    try {
      final model = SampleModel.fromEntity(entity);
      final result = await remoteDataSource.updateSample(model);
      await localDataSource.cacheSample(result);
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
  Future<Either<Failure, void>> deleteSample(String id) async {
    try {
      await remoteDataSource.deleteSample(id);
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
