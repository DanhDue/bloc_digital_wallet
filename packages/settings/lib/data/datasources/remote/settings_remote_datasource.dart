// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:framework/framework.dart';
import 'package:injectable/injectable.dart';
import 'package:settings/data/datasources/remote/settings_client.dart';
import 'package:settings/data/models/settings_model.dart';
import 'package:settings/domain/entities/settings_entity.dart';

@lazySingleton
class SettingsRemoteDataSource with SafeCallApiMixin {
  final SettingsClient _client;

  SettingsRemoteDataSource(this._client);

  Future<Either<Failure, SettingsEntity>> getSettings() async {
    final result = await safeApiCall(() => _client.getSettings());
    return result.map((model) => model.toEntity());
  }
}
