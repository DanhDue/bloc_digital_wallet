// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import '../../data/datasources/remote/{{subfeature_name.snakeCase()}}_remote_datasource.dart';
import '../../domain/entities/{{subfeature_name.snakeCase()}}_entity.dart';
import '../../domain/repositories/{{subfeature_name.snakeCase()}}_repository.dart';

@Injectable(as: {{subfeature_name.pascalCase()}}Repository)
class {{subfeature_name.pascalCase()}}RepositoryImpl implements {{subfeature_name.pascalCase()}}Repository {
  final {{subfeature_name.pascalCase()}}RemoteDataSource _remoteDataSource;

  {{subfeature_name.pascalCase()}}RepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, {{subfeature_name.pascalCase()}}Entity>> get{{subfeature_name.pascalCase()}}() async {
    try {
      final model = await _remoteDataSource.get{{subfeature_name.pascalCase()}}();
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
