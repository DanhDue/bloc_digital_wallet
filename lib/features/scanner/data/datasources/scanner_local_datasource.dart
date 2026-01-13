// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:injectable/injectable.dart';
import '../models/scanner_model.dart';

abstract class ScannerLocalDataSource {
  Future<void> cacheScanner(ScannerModel model);
  Future<ScannerModel?> getCachedScanner(String id);
  Future<List<ScannerModel>> getAllCachedScanners();
  Future<void> clearCache();
}

@LazySingleton(as: ScannerLocalDataSource)
class ScannerLocalDataSourceImpl implements ScannerLocalDataSource {
  // TODO: Inject Hive, SharedPreferences, or SecureStorage
  // final Box<ScannerModel> box;

  // const ScannerLocalDataSourceImpl(this.box);

  @override
  Future<void> cacheScanner(ScannerModel model) async {
    // TODO: Implement caching
    throw UnimplementedError();
  }

  @override
  Future<ScannerModel?> getCachedScanner(String id) async {
    // TODO: Implement cache retrieval
    throw UnimplementedError();
  }

  @override
  Future<List<ScannerModel>> getAllCachedScanners() async {
    // TODO: Implement cache retrieval
    throw UnimplementedError();
  }

  @override
  Future<void> clearCache() async {
    // TODO: Implement cache clearing
    throw UnimplementedError();
  }
}
