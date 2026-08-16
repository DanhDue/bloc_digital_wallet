// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:network/extensions/string_ext.dart';
import 'package:trends/data/datasources/remote/trends_uri.dart';
import 'package:trends/data/datasources/remote/trends_client.dart';

@module
abstract class TrendsNetworkModule {
  @lazySingleton
  TrendsClient trendsClient(Dio dio) =>
      TrendsClient(dio, baseUrl: TrendsUri.markets.buildAppUri());
}
