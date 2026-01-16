// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../features/authentication/data/datasources/remote/auth_client.dart';
import '../core/network/dio_factory.dart';

import '../../core/network/app_uri.dart';
import '../../core/utils/extensions/string_ext.dart';

@module
abstract class NetworkModule {
  @singleton
  Dio provideDio(Talker talker) => DioFactory(talker).dio;

  @singleton
  AuthClient provideAuthClient(Dio dio) => AuthClient(dio, baseUrl: AppUri.users.buildAppUri()!);
}
