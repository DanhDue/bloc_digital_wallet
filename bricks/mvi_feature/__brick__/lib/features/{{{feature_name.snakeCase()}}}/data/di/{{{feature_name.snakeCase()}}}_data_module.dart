// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:injectable/injectable.dart';
import '../datasources/{{{feature_name.snakeCase()}}}_local_datasource.dart';
import '../datasources/{{{feature_name.snakeCase()}}}_remote_datasource.dart';
import '../repositories/{{{feature_name.snakeCase()}}}_repository_impl.dart';
import '../../domain/repositories/{{{feature_name.snakeCase()}}}_repository.dart';

@module
abstract class {{feature_name.pascalCase()}}DataModule {
  @singleton
  {{feature_name.pascalCase()}}RemoteDataSource get remoteDataSource => {{feature_name.pascalCase()}}RemoteDataSourceImpl();

  @singleton
  {{feature_name.pascalCase()}}LocalDataSource get localDataSource => {{feature_name.pascalCase()}}LocalDataSourceImpl();

  @Singleton(as: {{feature_name.pascalCase()}}Repository)
  {{feature_name.pascalCase()}}RepositoryImpl get repository;
}
