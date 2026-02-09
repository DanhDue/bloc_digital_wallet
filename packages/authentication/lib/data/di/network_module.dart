// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:network/network.dart';

import 'package:authentication/data/datasources/remote/auth_client.dart';

/// Injectable module for registering network-related dependencies.
/// Contains Retrofit clients and related network configurations.
@module
abstract class NetworkModule {
  @lazySingleton
  AuthClient authClient(@Named('refreshDio') Dio dio) =>
      AuthClient(dio, baseUrl: AppUri.users.buildAppUri()!);
}
