// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:injectable/injectable.dart';
import '../models/home_model.dart';

abstract class HomeLocalDataSource {
  Future<void> cacheHome(HomeModel model);
  Future<HomeModel?> getCachedHome(String id);
  Future<List<HomeModel>> getAllCachedHomes();
  Future<void> clearCache();
}

@LazySingleton(as: HomeLocalDataSource)
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  // TODO: Inject Hive, SharedPreferences, or SecureStorage
  // final Box<HomeModel> box;

  // const HomeLocalDataSourceImpl(this.box);

  @override
  Future<void> cacheHome(HomeModel model) async {
    // TODO: Implement caching
    throw UnimplementedError();
  }

  @override
  Future<HomeModel?> getCachedHome(String id) async {
    // TODO: Implement cache retrieval
    throw UnimplementedError();
  }

  @override
  Future<List<HomeModel>> getAllCachedHomes() async {
    // TODO: Implement cache retrieval
    throw UnimplementedError();
  }

  @override
  Future<void> clearCache() async {
    // TODO: Implement cache clearing
    throw UnimplementedError();
  }
}
