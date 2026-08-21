// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:framework/framework.dart';
import 'package:settings/data/datasources/remote/settings_client.dart';
import 'package:settings/data/datasources/remote/translation_client.dart';
import 'package:settings/data/models/settings_model.dart';
import 'package:settings/data/models/sync/sync_bootstrap_request.dart';
import 'package:settings/data/models/sync/sync_bootstrap_response.dart';
import 'package:settings/data/models/sync/translation_override_response.dart';
import 'package:settings/domain/entities/settings_entity.dart';

@lazySingleton
class SettingsRemoteDataSource with SafeCallApiMixin {
  final SettingsClient _client;
  final TranslationClient _translationClient;

  SettingsRemoteDataSource(this._client, this._translationClient);

  Future<Either<Failure, SettingsEntity>> getSettings() async {
    final result = await safeApiCall(() => _client.getSettings());
    return result.map((model) => model.toEntity());
  }

  Future<Either<Failure, SyncBootstrapResponse>> bootstrap(SyncBootstrapRequest request) async {
    return safeApiCall(() async {
      final response = await _client.bootstrap(request);
      if (response.data == null) {
        throw Exception('Bootstrap response data is null');
      }
      return response.data!;
    });
  }

  Future<Either<Failure, TranslationOverrideData>> getLocalizationOverrides(
    String languageCode, {
    String? sinceVersion,
    String? eTag,
  }) async {
    return safeApiCall(() async {
      // Use TranslationClient (which now returns dynamic) to avoid strict Freezed parsing errors if backend format differs
      final data = await _translationClient.getLocalizationOverrides(
        languageCode,
        sinceVersion: sinceVersion,
        eTag: eTag,
      );

      if (data == null) {
        throw Exception('Translation override response data is null');
      }

      String version = '1.0.0';
      Map<String, dynamic> translations = {};

      if (data is Map<String, dynamic>) {
        if (data.containsKey('success') && data.containsKey('data')) {
          // It's wrapped in BaseResponseObject
          final innerData = data['data'];
          if (innerData is Map<String, dynamic>) {
            if (innerData.containsKey('version') && innerData.containsKey('translations')) {
              version = innerData['version'] as String? ?? '1.0.0';
              translations = innerData['translations'] as Map<String, dynamic>? ?? {};
            } else {
              // The inner data is directly the translations map
              translations = innerData;
            }
          }
        } else if (data.containsKey('version') && data.containsKey('translations')) {
          // Wrapped in TranslationOverrideData directly (no BaseResponseObject)
          version = data['version'] as String? ?? '1.0.0';
          translations = data['translations'] as Map<String, dynamic>? ?? {};
        } else {
          // It is the raw translations map directly
          translations = data;
        }
      }

      translations.remove('success');
      translations.remove('code');
      translations.remove('message');
      translations.remove('status');

      return TranslationOverrideData(version: version, translations: translations);
    });
  }
}
