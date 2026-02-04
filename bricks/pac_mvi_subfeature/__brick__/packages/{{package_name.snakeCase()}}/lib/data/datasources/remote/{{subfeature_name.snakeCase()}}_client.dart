// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/{{subfeature_name.snakeCase()}}_model.dart';
import 'package:network/network.dart';

part '{{subfeature_name.snakeCase()}}_client.g.dart';

@RestApi()
@injectable
abstract class {{subfeature_name.pascalCase()}}Client {
  @factoryMethod
  factory {{subfeature_name.pascalCase()}}Client(Dio dio, {@Named(AppUri.baseUrl) required String baseUrl}) =
      _{{subfeature_name.pascalCase()}}Client;

  @GET('/api/v1/{{subfeature_name.snakeCase()}}')
  Future<BaseResponseObject<{{subfeature_name.pascalCase()}}Model>> get{{subfeature_name.pascalCase()}}();
}
