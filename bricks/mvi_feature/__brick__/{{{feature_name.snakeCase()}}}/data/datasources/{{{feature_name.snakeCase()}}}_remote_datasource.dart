// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../models/{{{feature_name.snakeCase()}}}_model.dart';

abstract class {{feature_name.pascalCase()}}RemoteDataSource {
  Future<{{feature_name.pascalCase()}}Model> get{{feature_name.pascalCase()}}(String id);
  Future<List<{{feature_name.pascalCase()}}Model>> getAll{{feature_name.pascalCase()}}s();
  Future<{{feature_name.pascalCase()}}Model> create{{feature_name.pascalCase()}}({{feature_name.pascalCase()}}Model model);
  Future<{{feature_name.pascalCase()}}Model> update{{feature_name.pascalCase()}}({{feature_name.pascalCase()}}Model model);
  Future<void> delete{{feature_name.pascalCase()}}(String id);
}

class {{feature_name.pascalCase()}}RemoteDataSourceImpl implements {{feature_name.pascalCase()}}RemoteDataSource {
  // TODO: Inject Dio or Retrofit API client
  // final {{feature_name.pascalCase()}}ApiClient apiClient;
  
  // const {{feature_name.pascalCase()}}RemoteDataSourceImpl(this.apiClient);

  @override
  Future<{{feature_name.pascalCase()}}Model> get{{feature_name.pascalCase()}}(String id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<List<{{feature_name.pascalCase()}}Model>> getAll{{feature_name.pascalCase()}}s() async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<{{feature_name.pascalCase()}}Model> create{{feature_name.pascalCase()}}({{feature_name.pascalCase()}}Model model) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<{{feature_name.pascalCase()}}Model> update{{feature_name.pascalCase()}}({{feature_name.pascalCase()}}Model model) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<void> delete{{feature_name.pascalCase()}}(String id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }
}
