// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:settings/data/datasources/remote/settings_client.dart';

@module
abstract class SettingsNetworkModule {
  @lazySingleton
  SettingsClient settingsClient(Dio dio) => SettingsClient(dio);
}
