// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

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
  Future<Either<Failure, List<{{feature_name.pascalCase()}}Entity>>> get{{feature_name.pascalCase()}}s() async {
    try {
      final remoteData = await remoteDataSource.get{{feature_name.pascalCase()}}s();
      
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

}
