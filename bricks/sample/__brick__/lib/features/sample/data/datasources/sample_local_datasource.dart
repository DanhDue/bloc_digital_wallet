// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:injectable/injectable.dart';
import '../models/sample_model.dart';

abstract class SampleLocalDataSource {
  Future<void> cacheSample(SampleModel model);
  Future<SampleModel?> getCachedSample(String id);
  Future<List<SampleModel>> getAllCachedSamples();
  Future<void> clearCache();
}

@LazySingleton(as: SampleLocalDataSource)
class SampleLocalDataSourceImpl implements SampleLocalDataSource {
  // TODO: Inject Hive, SharedPreferences, or SecureStorage
  // final Box<SampleModel> box;
  
  // const SampleLocalDataSourceImpl(this.box);

  @override
  Future<void> cacheSample(SampleModel model) async {
    // TODO: Implement caching
    throw UnimplementedError();
  }

  @override
  Future<SampleModel?> getCachedSample(String id) async {
    // TODO: Implement cache retrieval
    throw UnimplementedError();
  }

  @override
  Future<List<SampleModel>> getAllCachedSamples() async {
    // TODO: Implement cache retrieval
    throw UnimplementedError();
  }

  @override
  Future<void> clearCache() async {
    // TODO: Implement cache clearing
    throw UnimplementedError();
  }
}
