// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:injectable/injectable.dart';
import '../models/sample_model.dart';

abstract class SampleRemoteDataSource {
  Future<SampleModel> getSample(String id);
  Future<List<SampleModel>> getAllSamples();
  Future<SampleModel> createSample(SampleModel model);
  Future<SampleModel> updateSample(SampleModel model);
  Future<void> deleteSample(String id);
}

@LazySingleton(as: SampleRemoteDataSource)
class SampleRemoteDataSourceImpl implements SampleRemoteDataSource {
  // TODO: Inject Dio or Retrofit API client
  // final SampleApiClient apiClient;
  
  // const SampleRemoteDataSourceImpl(this.apiClient);

  @override
  Future<SampleModel> getSample(String id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<List<SampleModel>> getAllSamples() async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<SampleModel> createSample(SampleModel model) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<SampleModel> updateSample(SampleModel model) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<void> deleteSample(String id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }
}
