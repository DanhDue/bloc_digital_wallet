// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:injectable/injectable.dart';
import '../models/{{{feature_name.snakeCase()}}}_model.dart';

abstract class {{feature_name.pascalCase()}}RemoteDataSource {
  Future<List<{{feature_name.pascalCase()}}Model>> get{{feature_name.pascalCase()}}s();
}

@LazySingleton(as: {{feature_name.pascalCase()}}RemoteDataSource)
class {{feature_name.pascalCase()}}RemoteDataSourceImpl implements {{feature_name.pascalCase()}}RemoteDataSource {
  // TODO: Inject Dio or Retrofit API client
  // final {{feature_name.pascalCase()}}ApiClient apiClient;
  
  // const {{feature_name.pascalCase()}}RemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<{{feature_name.pascalCase()}}Model>> get{{feature_name.pascalCase()}}s() async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

}
