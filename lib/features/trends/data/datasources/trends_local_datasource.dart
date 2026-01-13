// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:injectable/injectable.dart';
import '../models/trends_model.dart';

abstract class TrendsLocalDataSource {
  Future<void> cacheTrends(TrendsModel model);
  Future<TrendsModel?> getCachedTrends(String id);
  Future<List<TrendsModel>> getAllCachedTrendss();
  Future<void> clearCache();
}

@LazySingleton(as: TrendsLocalDataSource)
class TrendsLocalDataSourceImpl implements TrendsLocalDataSource {
  // TODO: Inject Hive, SharedPreferences, or SecureStorage
  // final Box<TrendsModel> box;

  // const TrendsLocalDataSourceImpl(this.box);

  @override
  Future<void> cacheTrends(TrendsModel model) async {
    // TODO: Implement caching
    throw UnimplementedError();
  }

  @override
  Future<TrendsModel?> getCachedTrends(String id) async {
    // TODO: Implement cache retrieval
    throw UnimplementedError();
  }

  @override
  Future<List<TrendsModel>> getAllCachedTrendss() async {
    // TODO: Implement cache retrieval
    throw UnimplementedError();
  }

  @override
  Future<void> clearCache() async {
    // TODO: Implement cache clearing
    throw UnimplementedError();
  }
}
