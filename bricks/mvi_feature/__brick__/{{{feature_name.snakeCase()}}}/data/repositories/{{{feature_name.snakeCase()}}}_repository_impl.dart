// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/{{{feature_name.snakeCase()}}}_entity.dart';
import '../../domain/repositories/{{{feature_name.snakeCase()}}}_repository.dart';
import '../datasources/{{{feature_name.snakeCase()}}}_local_datasource.dart';
import '../datasources/{{{feature_name.snakeCase()}}}_remote_datasource.dart';
import '../models/{{{feature_name.snakeCase()}}}_model.dart';

@LazySingleton(as: {{feature_name.pascalCase()}}Repository)
class {{feature_name.pascalCase()}}RepositoryImpl implements {{feature_name.pascalCase()}}Repository {
  final {{feature_name.pascalCase()}}RemoteDataSource remoteDataSource;
  final {{feature_name.pascalCase()}}LocalDataSource localDataSource;

  {{feature_name.pascalCase()}}RepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, {{feature_name.pascalCase()}}Entity>> get{{feature_name.pascalCase()}}(String id) async {
    try {
      // Try cache first
      final cachedData = await localDataSource.getCached{{feature_name.pascalCase()}}(id);
      if (cachedData != null) {
        return Right(cachedData.toEntity());
      }

      // Fetch from remote
      final remoteData = await remoteDataSource.get{{feature_name.pascalCase()}}(id);
      await localDataSource.cache{{feature_name.pascalCase()}}(remoteData);
      
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
  Future<Either<Failure, List<{{feature_name.pascalCase()}}Entity>>> getAll{{feature_name.pascalCase()}}s() async {
    try {
      final remoteData = await remoteDataSource.getAll{{feature_name.pascalCase()}}s();
      
      // Cache all items
      for (final item in remoteData) {
        await localDataSource.cache{{feature_name.pascalCase()}}(item);
      }
      
      return Right(remoteData.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      // Try cache on failure
      try {
        final cachedData = await localDataSource.getAllCached{{feature_name.pascalCase()}}s();
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
  Future<Either<Failure, {{feature_name.pascalCase()}}Entity>> create{{feature_name.pascalCase()}}(
      {{feature_name.pascalCase()}}Entity entity) async {
    try {
      final model = {{feature_name.pascalCase()}}Model.fromEntity(entity);
      final result = await remoteDataSource.create{{feature_name.pascalCase()}}(model);
      await localDataSource.cache{{feature_name.pascalCase()}}(result);
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
  Future<Either<Failure, {{feature_name.pascalCase()}}Entity>> update{{feature_name.pascalCase()}}(
      {{feature_name.pascalCase()}}Entity entity) async {
    try {
      final model = {{feature_name.pascalCase()}}Model.fromEntity(entity);
      final result = await remoteDataSource.update{{feature_name.pascalCase()}}(model);
      await localDataSource.cache{{feature_name.pascalCase()}}(result);
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
  Future<Either<Failure, void>> delete{{feature_name.pascalCase()}}(String id) async {
    try {
      await remoteDataSource.delete{{feature_name.pascalCase()}}(id);
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
