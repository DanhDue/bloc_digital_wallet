// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:convert';

import 'package:core/core.dart';
import 'package:framework/framework.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:settings/data/datasources/remote/settings_client.dart';
import 'package:settings/data/models/settings_model.dart';
import 'package:settings/data/models/sync/sync_bootstrap_request.dart';
import 'package:settings/data/models/sync/sync_bootstrap_response.dart';
import 'package:settings/domain/entities/settings_entity.dart';

@lazySingleton
class SettingsRemoteDataSource with SafeCallApiMixin {
  final SettingsClient _client;
  final Dio _dio;

  SettingsRemoteDataSource(this._client, this._dio);

  Future<Either<Failure, SettingsEntity>> getSettings() async {
    final result = await safeApiCall(() => _client.getSettings());
    return result.map((model) => model.toEntity());
  }

  Future<Either<Failure, SyncBootstrapResponse>> bootstrap(SyncBootstrapRequest request) async {
    return safeApiCall(() => _client.bootstrap(request));
  }

  Future<Either<Failure, Map<String, dynamic>>> fetchTranslationJson(String url) async {
    return safeApiCall(() async {
      final response = await _dio.get(url);
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else if (response.data is String) {
        return jsonDecode(response.data) as Map<String, dynamic>;
      }
      throw Exception('Invalid JSON response');
    });
  }
}
