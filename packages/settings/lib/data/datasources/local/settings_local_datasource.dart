// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:settings/data/models/sync/available_language.dart';

abstract class SettingsLocalDataSource {
  Future<String?> getCachedTranslationVersion(String languageCode);
  Future<void> saveCachedTranslationVersion(String languageCode, String version);

  Future<Map<String, dynamic>?> getCachedTranslationJson(String languageCode);
  Future<void> saveCachedTranslationJson(String languageCode, Map<String, dynamic> json);
  Future<void> deleteCachedTranslation(String languageCode);

  Future<List<String>> getAllCachedLanguageCodes();

  Future<void> saveAvailableLanguages(List<AvailableLanguage> languages);
  Future<List<AvailableLanguage>> getAvailableLanguages();

  Future<Map<String, dynamic>> loadBundledFallback(String languageCode);

  /// Explicit module-logging overrides, keyed by module name. A module
  /// absent from the returned map means "use default: enabled", matching
  /// `LogManagerImpl`'s own `?? true` default. Returns an empty map when
  /// nothing has been persisted yet.
  Future<Map<String, bool>> getModuleToggles();

  /// Persists [toggles] (module name -> explicit enabled override) under
  /// the `logging.module_toggles` key.
  Future<void> saveModuleToggles(Map<String, bool> toggles);

  /// Explicit appender-logging overrides, keyed by appender id
  /// (`'talker'`/`'datadog'`/`'otel'`). An appender absent from the
  /// returned map means "use default: enabled". Returns an empty map when
  /// nothing has been persisted yet.
  Future<Map<String, bool>> getAppenderToggles();

  /// Persists [toggles] (appender id -> explicit enabled override) under
  /// the `logging.appender_toggles` key.
  Future<void> saveAppenderToggles(Map<String, bool> toggles);
}
