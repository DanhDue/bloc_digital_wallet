// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:injectable/injectable.dart';
import '../models/home_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeModel> getHome(String id);
  Future<List<HomeModel>> getAllHomes();
  Future<HomeModel> createHome(HomeModel model);
  Future<HomeModel> updateHome(HomeModel model);
  Future<void> deleteHome(String id);
}

@LazySingleton(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  // TODO: Inject Dio or Retrofit API client
  // final HomeApiClient apiClient;

  // const HomeRemoteDataSourceImpl(this.apiClient);

  @override
  Future<HomeModel> getHome(String id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<List<HomeModel>> getAllHomes() async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<HomeModel> createHome(HomeModel model) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<HomeModel> updateHome(HomeModel model) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<void> deleteHome(String id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }
}
