// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:framework/framework.dart';
import 'package:injectable/injectable.dart';
import 'package:home/data/datasources/remote/home_client.dart';

import 'package:home/domain/entities/home_entity.dart';

@lazySingleton
class HomeRemoteDataSource with SafeCallApiMixin {
  final HomeClient _client;

  HomeRemoteDataSource(this._client);

  Future<Either<Failure, HomeEntity>> getHome() async {
    final result = await safeApiCall(() => _client.getHome());
    return result.map((model) => model.toEntity());
  }
}
