// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:settings/data/datasources/local/settings_local_datasource.dart';
import 'package:settings/data/models/sync/available_language.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: SettingsLocalDataSource)
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences _sharedPreferences;
  static const _translationVersionPrefix = 'translation_version_';
  static const _availableLanguagesKey = 'available_languages';
  static const _cachedLanguageCodesKey = 'cached_language_codes';
  static const _moduleTogglesKey = 'logging.module_toggles';
  static const _appenderTogglesKey = 'logging.appender_toggles';

  SettingsLocalDataSourceImpl(this._sharedPreferences);

  @override
  Future<String?> getCachedTranslationVersion(String languageCode) async {
    final meta = _readVersionMeta(languageCode);
    return meta?.version;
  }

  @override
  Future<void> saveCachedTranslationVersion(
    String languageCode,
    String version,
    String checksum,
  ) async {
    // Version and checksum are written as a single value under one key so
    // they can never independently desync from a crash between two separate
    // writes.
    await _sharedPreferences.setString(
      '$_translationVersionPrefix$languageCode',
      jsonEncode({'version': version, 'checksum': checksum}),
    );

    // Update the list of cached language codes
    final codes = await getAllCachedLanguageCodes();
    if (!codes.contains(languageCode)) {
      codes.add(languageCode);
      await _sharedPreferences.setStringList(_cachedLanguageCodesKey, codes);
    }
  }

  @override
  Future<Map<String, dynamic>?> getCachedTranslationJson(String languageCode) async {
    final file = await _getTranslationFile(languageCode);
    if (!await file.exists()) {
      return null;
    }
    try {
      final jsonString = await file.readAsString();
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;

      final expectedChecksum = _readVersionMeta(languageCode)?.checksum;
      if (expectedChecksum != null && ChecksumUtils.computeSha256(jsonMap) != expectedChecksum) {
        // The cached file's content no longer matches the checksum saved
        // alongside its version - the two writes desynced (e.g. a crash
        // between saving the file and saving the version+checksum).
        // Treat as corrupt rather than silently serving stale/wrong content
        // or feeding a wrong base into the next delta merge.
        await deleteCachedTranslation(languageCode);
        return null;
      }

      return jsonMap;
    } catch (e) {
      return null;
    }
  }

  /// Reads and parses the combined version+checksum value for [languageCode].
  /// Returns `null` if nothing is cached yet, or if the value predates
  /// checksum tracking (a bare version string) - in which case `checksum`
  /// is also `null`, and callers should treat the cache as unverifiable
  /// rather than corrupt.
  _VersionMeta? _readVersionMeta(String languageCode) {
    final raw = _sharedPreferences.getString('$_translationVersionPrefix$languageCode');
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return _VersionMeta(decoded['version'] as String?, decoded['checksum'] as String?);
    } catch (_) {
      // Legacy format: a bare version string saved before checksum tracking existed.
      return _VersionMeta(raw, null);
    }
  }

  @override
  Future<void> saveCachedTranslationJson(String languageCode, Map<String, dynamic> jsonMap) async {
    final file = await _getTranslationFile(languageCode);
    // Write atomically
    final tempFile = File('${file.path}.tmp');
    await tempFile.writeAsString(jsonEncode(jsonMap));
    await tempFile.rename(file.path);

    final codes = await getAllCachedLanguageCodes();
    if (!codes.contains(languageCode)) {
      codes.add(languageCode);
      await _sharedPreferences.setStringList(_cachedLanguageCodesKey, codes);
    }
  }

  @override
  Future<void> deleteCachedTranslation(String languageCode) async {
    final file = await _getTranslationFile(languageCode);
    if (await file.exists()) {
      await file.delete();
    }
    await _sharedPreferences.remove('$_translationVersionPrefix$languageCode');

    final codes = await getAllCachedLanguageCodes();
    if (codes.contains(languageCode)) {
      codes.remove(languageCode);
      await _sharedPreferences.setStringList(_cachedLanguageCodesKey, codes);
    }
  }

  @override
  Future<List<String>> getAllCachedLanguageCodes() async {
    return _sharedPreferences.getStringList(_cachedLanguageCodesKey) ?? [];
  }

  @override
  Future<void> saveAvailableLanguages(List<AvailableLanguage> languages) async {
    final jsonList = languages.map((e) => e.toJson()).toList();
    await _sharedPreferences.setString(_availableLanguagesKey, jsonEncode(jsonList));
  }

  @override
  Future<List<AvailableLanguage>> getAvailableLanguages() async {
    final jsonString = _sharedPreferences.getString(_availableLanguagesKey);
    if (jsonString == null) return [];

    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((e) => AvailableLanguage.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> loadBundledFallback(String languageCode) async {
    final Map<String, dynamic> combinedJson = {};

    final candidatePaths = [
      'assets/locales/$languageCode.i18n.json',
      'packages/core/assets/locales/$languageCode.i18n.json',
      'packages/scanner/assets/locales/$languageCode.i18n.json',
      'packages/settings/assets/locales/$languageCode.i18n.json',
      'features/scanner/assets/locales/$languageCode.i18n.json',
      'features/settings/assets/locales/$languageCode.i18n.json',
    ];

    for (final path in candidatePaths) {
      try {
        final content = await rootBundle.loadString(path);
        final jsonMap = jsonDecode(content) as Map<String, dynamic>;
        combinedJson.addAll(jsonMap);
      } catch (_) {
        // Continue checking fallback candidate paths
      }
    }

    return combinedJson;
  }

  @override
  Future<Map<String, bool>> getModuleToggles() async {
    return _getToggleMap(_moduleTogglesKey);
  }

  @override
  Future<void> saveModuleToggles(Map<String, bool> toggles) async {
    await _sharedPreferences.setString(_moduleTogglesKey, jsonEncode(toggles));
  }

  @override
  Future<Map<String, bool>> getAppenderToggles() async {
    return _getToggleMap(_appenderTogglesKey);
  }

  @override
  Future<void> saveAppenderToggles(Map<String, bool> toggles) async {
    await _sharedPreferences.setString(_appenderTogglesKey, jsonEncode(toggles));
  }

  Map<String, bool> _getToggleMap(String key) {
    final jsonString = _sharedPreferences.getString(key);
    if (jsonString == null) return {};

    try {
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, value as bool));
    } catch (e) {
      return {};
    }
  }

  Future<File> _getTranslationFile(String languageCode) async {
    final directory = await getApplicationCacheDirectory();
    final path = '${directory.path}/translations';
    final dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return File('$path/$languageCode.json');
  }
}

class _VersionMeta {
  final String? version;
  final String? checksum;

  const _VersionMeta(this.version, this.checksum);
}
