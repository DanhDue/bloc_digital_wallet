// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:settings/domain/entities/settings_entity.dart';
import 'package:settings/data/models/sync/sync_bootstrap_request.dart';
import 'package:settings/data/models/sync/sync_bootstrap_response.dart';
import 'package:settings/data/models/sync/translation_override_response.dart';
import 'package:settings/data/models/sync/available_language.dart';

abstract class SettingsRepository {
  Future<Either<Failure, SettingsEntity>> getSettings();

  Future<Either<Failure, SyncBootstrapResponse>> bootstrap(SyncBootstrapRequest request);

  Future<Either<Failure, TranslationOverrideData>> getLocalizationOverrides(
    String languageCode, {
    String? sinceVersion,
    String? eTag,
  });

  Future<Either<Failure, String?>> getCachedTranslationVersion(String languageCode);

  /// Persists [version] together with [checksum] (the SHA-256 of the cached
  /// translation JSON, via [ChecksumUtils.computeSha256]) so that a later
  /// read can detect the two ever having desynced - e.g. a crash between
  /// this call and [saveCachedTranslationJson].
  Future<Either<Failure, void>> saveCachedTranslationVersion(
    String languageCode,
    String version,
    String checksum,
  );
  Future<Either<Failure, Map<String, dynamic>?>> getCachedTranslationJson(String languageCode);
  Future<Either<Failure, void>> saveCachedTranslationJson(
    String languageCode,
    Map<String, dynamic> json,
  );
  Future<Either<Failure, void>> deleteCachedTranslation(String languageCode);
  Future<Either<Failure, List<String>>> getAllCachedLanguageCodes();
  Future<Either<Failure, void>> saveAvailableLanguages(List<AvailableLanguage> languages);
  Future<Either<Failure, List<AvailableLanguage>>> getAvailableLanguages();
  Future<Either<Failure, Map<String, dynamic>>> loadBundledFallback(String languageCode);
}
