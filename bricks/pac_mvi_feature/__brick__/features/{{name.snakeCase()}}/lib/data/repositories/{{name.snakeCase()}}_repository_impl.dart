// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:{{name.snakeCase()}}/data/datasources/remote/{{name.snakeCase()}}_remote_datasource.dart';
import 'package:{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}_entity.dart';
import 'package:{{name.snakeCase()}}/domain/repositories/{{name.snakeCase()}}_repository.dart';

@LazySingleton(as: {{name.pascalCase()}}Repository)
class {{name.pascalCase()}}RepositoryImpl implements {{name.pascalCase()}}Repository {
  final {{name.pascalCase()}}RemoteDataSource _remoteDataSource;

  {{name.pascalCase()}}RepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, {{name.pascalCase()}}Entity>> get{{name.pascalCase()}}() {
    return _remoteDataSource.get{{name.pascalCase()}}();
  }
}
