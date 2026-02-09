// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:home/data/datasources/remote/home_remote_datasource.dart';
import 'package:home/domain/entities/home_entity.dart';
import 'package:home/domain/repositories/home_repository.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, HomeEntity>> getHome() {
    return _remoteDataSource.getHome();
  }
}
