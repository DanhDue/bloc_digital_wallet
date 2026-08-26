// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:convert';
import 'dart:io';

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
    return _sharedPreferences.getString('$_translationVersionPrefix$languageCode');
  }

  @override
  Future<void> saveCachedTranslationVersion(String languageCode, String version) async {
    await _sharedPreferences.setString('$_translationVersionPrefix$languageCode', version);

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
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveCachedTranslationJson(String languageCode, Map<String, dynamic> jsonMap) async {
    final file = await _getTranslationFile(languageCode);
    // Write atomically
    final tempFile = File('${file.path}.tmp');
    await tempFile.writeAsString(jsonEncode(jsonMap));
    await tempFile.rename(file.path);
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
    final List<String> packageNames = [
      'core',
      'authentication',
      'onboard',
      'home',
      'scanner',
      'trends',
      'wallet',
      'transaction',
      'settings',
    ];

    final Map<String, dynamic> combinedJson = {};

    // Load root app locale
    try {
      final rootString = await rootBundle.loadString('assets/locales/$languageCode.i18n.json');
      final rootJson = jsonDecode(rootString) as Map<String, dynamic>;
      combinedJson.addAll(rootJson);
    } catch (_) {
      // Ignore if not found
    }

    // Load packages locales
    for (final package in packageNames) {
      try {
        final packageString = await rootBundle.loadString(
          'packages/$package/assets/locales/$languageCode.i18n.json',
        );
        final packageJson = jsonDecode(packageString) as Map<String, dynamic>;
        combinedJson.addAll(packageJson);
      } catch (_) {
        // Ignore if package locale not found
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
