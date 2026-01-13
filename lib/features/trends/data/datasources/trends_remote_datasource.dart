// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:injectable/injectable.dart';
import '../models/trends_model.dart';

abstract class TrendsRemoteDataSource {
  Future<TrendsModel> getTrends(String id);
  Future<List<TrendsModel>> getAllTrendss();
  Future<TrendsModel> createTrends(TrendsModel model);
  Future<TrendsModel> updateTrends(TrendsModel model);
  Future<void> deleteTrends(String id);
}

@LazySingleton(as: TrendsRemoteDataSource)
class TrendsRemoteDataSourceImpl implements TrendsRemoteDataSource {
  // TODO: Inject Dio or Retrofit API client
  // final TrendsApiClient apiClient;

  // const TrendsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<TrendsModel> getTrends(String id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<List<TrendsModel>> getAllTrendss() async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<TrendsModel> createTrends(TrendsModel model) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<TrendsModel> updateTrends(TrendsModel model) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTrends(String id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }
}
