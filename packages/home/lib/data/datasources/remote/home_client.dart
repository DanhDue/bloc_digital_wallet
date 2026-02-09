// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:home/data/models/home_model.dart';

part 'home_client.g.dart';

@RestApi()
abstract class HomeClient {
  factory HomeClient(Dio dio, {String? baseUrl}) = _HomeClient;

  @GET('/home')
  Future<HomeModel> getHome();
}
