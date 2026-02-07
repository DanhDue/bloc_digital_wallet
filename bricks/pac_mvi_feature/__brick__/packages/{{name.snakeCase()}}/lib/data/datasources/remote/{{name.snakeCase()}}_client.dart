// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:{{name.snakeCase()}}/data/models/{{name.snakeCase()}}_model.dart';

part '{{name.snakeCase()}}_client.g.dart';

@RestApi()
abstract class {{name.pascalCase()}}Client {
  factory {{name.pascalCase()}}Client(Dio dio, {String? baseUrl}) = _{{name.pascalCase()}}Client;

  @GET('/{{name.snakeCase()}}')
  Future<{{name.pascalCase()}}Model> get{{name.pascalCase()}}();
}
