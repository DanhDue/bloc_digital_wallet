// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:injectable/injectable.dart';
import '../models/settings_model.dart';

abstract class SettingsRemoteDataSource {
  Future<List<SettingsModel>> getSettingss();
}

@LazySingleton(as: SettingsRemoteDataSource)
class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  // TODO: Inject Dio or Retrofit API client
  // final SettingsApiClient apiClient;

  // const SettingsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<SettingsModel>> getSettingss() async {
    // TODO: Implement API call
    throw UnimplementedError();
  }
}
