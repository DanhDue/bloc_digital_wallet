// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:core/generated/translations.dart';
import 'package:core/localization/dynamic_translator.dart';
import 'package:core/utils/log.dart';

/// Manages the application's locale state and provides a stream for updates.
class LocalizationManager {
  // Singleton instance
  static final LocalizationManager instance = LocalizationManager._();

  LocalizationManager._();

  // Stream controller for locale changes
  final _localeController = BehaviorSubject<Locale>.seeded(
    LocaleSettings.currentLocale.flutterLocale,
  );

  /// Stream of locale changes
  Stream<Locale> get localeStream => _localeController.stream;

  Future<void> Function(Map<String, dynamic> json, Locale locale)? _overrideCallback;
  Future<void> Function(Locale locale)? _syncLocaleCallback;

  /// Register callback for dynamic translations
  void registerOverrideCallback(
    Future<void> Function(Map<String, dynamic> json, Locale locale) callback,
  ) {
    _overrideCallback = callback;
  }

  /// Register callback to sync locale changes across all packages
  void registerSyncLocaleCallback(Future<void> Function(Locale locale) callback) {
    _syncLocaleCallback = callback;
  }

  Future<void> applyDynamicTranslations(
    Map<String, dynamic> mergedJson, {
    String? targetLanguageCode,
  }) async {
    Log.d('LocalizationManager.applyDynamicTranslations: targetLanguageCode=$targetLanguageCode');
    // Nạp luôn cho Từ điển động (Dùng cho các Dynamic Keys)
    final dynamicSection = mergedJson['dynamic'] as Map<String, dynamic>? ?? {};
    DynamicTranslator.updateJson(dynamicSection);

    Locale localeToOverride = currentLocale;
    if (targetLanguageCode != null) {
      localeToOverride = resolveLocale(targetLanguageCode);
    }

    if (_overrideCallback != null) {
      Log.d(
        'LocalizationManager.applyDynamicTranslations: Calling _overrideCallback for $localeToOverride',
      );
      await _overrideCallback!(mergedJson, localeToOverride);
      _localeController.add(currentLocale);
      Log.d('LocalizationManager.applyDynamicTranslations: Overrides applied and UI notified');
    }
  }

  Locale resolveLocale(String languageCode) {
    final code = languageCode.replaceAll('-', '_');
    final parts = code.split('_');
    final String targetCode;

    if (AppLocaleUtils.supportedLocalesRaw.contains(code)) {
      targetCode = code;
    } else if (parts.isNotEmpty && AppLocaleUtils.supportedLocalesRaw.contains(parts[0])) {
      targetCode = parts[0];
    } else {
      targetCode = code;
    }

    final targetParts = targetCode.split('_');
    return targetParts.length > 1
        ? Locale(targetParts[0], targetParts[1])
        : Locale(targetParts[0]);
  }

  Future<void> setLocaleFromCode(String languageCode) async {
    Log.d('LocalizationManager.setLocaleFromCode: $languageCode');
    final locale = resolveLocale(languageCode);
    await setLocale(locale, originalCode: languageCode);
  }

  /// Get current locale
  Locale get currentLocale => LocaleSettings.currentLocale.flutterLocale;

  /// Set the locale for the application
  Future<void> setLocale(Locale locale, {String? originalCode}) async {
    Log.d('LocalizationManager.setLocale: locale=$locale, originalCode=$originalCode');
    // This updates the internal state of slang for the core package.
    final rawLocale = locale.countryCode != null
        ? '${locale.languageCode}_${locale.countryCode}'
        : locale.languageCode;
    await LocaleSettings.setLocaleRaw(rawLocale);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_language_code', originalCode ?? rawLocale);

    if (_syncLocaleCallback != null) {
      Log.d('LocalizationManager.setLocale: Calling _syncLocaleCallback');
      await _syncLocaleCallback!(locale);
    }

    // Notify listeners
    _localeController.add(locale);
    Log.d('LocalizationManager.setLocale: Completed for $locale');
  }

  /// Get supported locales
  List<Locale> get supportedLocales => AppLocaleUtils.supportedLocales;
}
