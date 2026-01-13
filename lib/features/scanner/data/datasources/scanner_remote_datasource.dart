// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:injectable/injectable.dart';
import '../models/scanner_model.dart';

abstract class ScannerRemoteDataSource {
  Future<ScannerModel> getScanner(String id);
  Future<List<ScannerModel>> getAllScanners();
  Future<ScannerModel> createScanner(ScannerModel model);
  Future<ScannerModel> updateScanner(ScannerModel model);
  Future<void> deleteScanner(String id);
}

@LazySingleton(as: ScannerRemoteDataSource)
class ScannerRemoteDataSourceImpl implements ScannerRemoteDataSource {
  // TODO: Inject Dio or Retrofit API client
  // final ScannerApiClient apiClient;

  // const ScannerRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ScannerModel> getScanner(String id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<List<ScannerModel>> getAllScanners() async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<ScannerModel> createScanner(ScannerModel model) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<ScannerModel> updateScanner(ScannerModel model) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<void> deleteScanner(String id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }
}
