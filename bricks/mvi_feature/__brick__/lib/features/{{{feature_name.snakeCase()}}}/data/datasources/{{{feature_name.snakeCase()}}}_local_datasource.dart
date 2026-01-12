// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import '../models/{{{feature_name.snakeCase()}}}_model.dart';

abstract class {{feature_name.pascalCase()}}LocalDataSource {
  Future<void> cache{{feature_name.pascalCase()}}({{feature_name.pascalCase()}}Model model);
  Future<{{feature_name.pascalCase()}}Model?> getCached{{feature_name.pascalCase()}}(String id);
  Future<List<{{feature_name.pascalCase()}}Model>> getAllCached{{feature_name.pascalCase()}}s();
  Future<void> clearCache();
}

class {{feature_name.pascalCase()}}LocalDataSourceImpl implements {{feature_name.pascalCase()}}LocalDataSource {
  // TODO: Inject Hive, SharedPreferences, or SecureStorage
  // final Box<{{feature_name.pascalCase()}}Model> box;
  
  // const {{feature_name.pascalCase()}}LocalDataSourceImpl(this.box);

  @override
  Future<void> cache{{feature_name.pascalCase()}}({{feature_name.pascalCase()}}Model model) async {
    // TODO: Implement caching
    throw UnimplementedError();
  }

  @override
  Future<{{feature_name.pascalCase()}}Model?> getCached{{feature_name.pascalCase()}}(String id) async {
    // TODO: Implement cache retrieval
    throw UnimplementedError();
  }

  @override
  Future<List<{{feature_name.pascalCase()}}Model>> getAllCached{{feature_name.pascalCase()}}s() async {
    // TODO: Implement cache retrieval
    throw UnimplementedError();
  }

  @override
  Future<void> clearCache() async {
    // TODO: Implement cache clearing
    throw UnimplementedError();
  }
}
