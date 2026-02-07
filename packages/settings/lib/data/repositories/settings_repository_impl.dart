// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:settings/data/datasources/remote/settings_remote_datasource.dart';
import 'package:settings/domain/entities/settings_entity.dart';
import 'package:settings/domain/repositories/settings_repository.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource _remoteDataSource;

  SettingsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, SettingsEntity>> getSettings() {
    return _remoteDataSource.getSettings();
  }
}
