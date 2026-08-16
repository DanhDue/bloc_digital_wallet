// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:network/extensions/string_ext.dart';
import 'package:{{name.snakeCase()}}/data/datasources/remote/{{name.snakeCase()}}_uri.dart';
import 'package:{{name.snakeCase()}}/data/datasources/remote/{{name.snakeCase()}}_client.dart';

@module
abstract class {{name.pascalCase()}}NetworkModule {
  @lazySingleton
  {{name.pascalCase()}}Client {{name.camelCase()}}Client(Dio dio) =>
      {{name.pascalCase()}}Client(dio, baseUrl: {{name.pascalCase()}}Uri.{{name.camelCase()}}.buildAppUri());
}
