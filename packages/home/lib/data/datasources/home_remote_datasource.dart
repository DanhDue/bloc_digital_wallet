// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../models/home_model.dart';

part 'home_remote_datasource.g.dart';

@RestApi()
abstract class HomeRemoteDataSource {
  @factoryMethod
  factory HomeRemoteDataSource(Dio dio) = _HomeRemoteDataSource;

  @GET('/api/v1/home/{id}')
  Future<HomeModel> getHome(@Path('id') String id);

  @GET('/api/v1/homes')
  Future<List<HomeModel>> getAllHomes();
}
