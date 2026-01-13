// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:injectable/injectable.dart';
import '../models/settings_model.dart';

abstract class SettingsLocalDataSource {
  Future<void> cacheSettings(SettingsModel model);
  Future<List<SettingsModel>> getAllCachedSettingss();
  Future<void> clearCache();
}

@LazySingleton(as: SettingsLocalDataSource)
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  // TODO: Inject Hive, SharedPreferences, or SecureStorage
  // final Box<SettingsModel> box;

  // const SettingsLocalDataSourceImpl(this.box);

  @override
  Future<void> cacheSettings(SettingsModel model) async {
    // TODO: Implement caching
    throw UnimplementedError();
  }

  @override
  Future<List<SettingsModel>> getAllCachedSettingss() async {
    // TODO: Implement cache retrieval
    throw UnimplementedError();
  }

  @override
  Future<void> clearCache() async {
    // TODO: Implement cache clearing
    throw UnimplementedError();
  }
}
