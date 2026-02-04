// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:injectable/injectable.dart';

import '{{subfeature_name.snakeCase()}}_client.dart';
import '../../models/{{subfeature_name.snakeCase()}}_model.dart';

abstract class {{subfeature_name.pascalCase()}}RemoteDataSource {
  Future<{{subfeature_name.pascalCase()}}Model> get{{subfeature_name.pascalCase()}}();
}

@Injectable(as: {{subfeature_name.pascalCase()}}RemoteDataSource)
class {{subfeature_name.pascalCase()}}RemoteDataSourceImpl implements {{subfeature_name.pascalCase()}}RemoteDataSource {
  final {{subfeature_name.pascalCase()}}Client _client;

  {{subfeature_name.pascalCase()}}RemoteDataSourceImpl(this._client);

  @override
  Future<{{subfeature_name.pascalCase()}}Model> get{{subfeature_name.pascalCase()}}() async {
    final response = await _client.get{{subfeature_name.pascalCase()}}();
    return response.data!;
  }
}
