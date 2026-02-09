// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:network/network.dart';
import 'package:home/data/datasources/remote/home_client.dart';

@module
abstract class HomeNetworkModule {
  @lazySingleton
  HomeClient homeClient(Dio dio) => HomeClient(dio, baseUrl: AppUri.home.buildAppUri());
}
