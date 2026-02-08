// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:trends/data/datasources/remote/trends_remote_datasource.dart';
import 'package:trends/domain/entities/trends_entity.dart';
import 'package:trends/domain/repositories/trends_repository.dart';

@LazySingleton(as: TrendsRepository)
class TrendsRepositoryImpl implements TrendsRepository {
  final TrendsRemoteDataSource _remoteDataSource;

  TrendsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, TrendsEntity>> getTrends() {
    return _remoteDataSource.getTrends();
  }
}
