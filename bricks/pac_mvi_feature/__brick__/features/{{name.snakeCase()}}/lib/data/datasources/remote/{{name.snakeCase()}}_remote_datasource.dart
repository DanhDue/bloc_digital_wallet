// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:framework/framework.dart';
import 'package:injectable/injectable.dart';
import 'package:{{name.snakeCase()}}/data/datasources/remote/{{name.snakeCase()}}_client.dart';
import 'package:{{name.snakeCase()}}/data/models/{{name.snakeCase()}}_model.dart';
import 'package:{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}_entity.dart';

@lazySingleton
class {{name.pascalCase()}}RemoteDataSource with SafeCallApiMixin {
  final {{name.pascalCase()}}Client _client;

  {{name.pascalCase()}}RemoteDataSource(this._client);

  Future<Either<Failure, {{name.pascalCase()}}Entity>> get{{name.pascalCase()}}() async {
    final result = await safeApiCall(() => _client.get{{name.pascalCase()}}());
    return result.map(({{name.pascalCase()}}Model model) => model.toEntity());
  }
}
