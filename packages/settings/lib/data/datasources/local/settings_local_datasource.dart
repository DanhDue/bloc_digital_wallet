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
}
