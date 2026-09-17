// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:network/extensions/string_ext.dart';
import 'package:authentication/data/datasources/remote/authentication_uri.dart';

import 'package:authentication/data/datasources/remote/auth_client.dart';

/// Injectable module for registering network-related dependencies.
/// Contains Retrofit clients and related network configurations.
@module
abstract class AuthenticationNetworkModule {
  @lazySingleton
  AuthClient authClient(@Named('refreshDio') Dio dio) =>
      AuthClient(dio, baseUrl: AuthenticationUri.users.buildAppUri()!);
}
