// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:async';
import 'package:flutter/material.dart';
import '../generated/translations.dart';

/// Manages the application's locale state and provides a stream for updates.
class LocalizationManager {
  // Singleton instance
  static final LocalizationManager instance = LocalizationManager._();

  LocalizationManager._();

  // Stream controller for locale changes
  final _localeController = StreamController<Locale>.broadcast();

  /// Stream of locale changes
  Stream<Locale> get localeStream => _localeController.stream;

  /// Get current locale
  Locale get currentLocale => LocaleSettings.currentLocale.flutterLocale;

  /// Set the locale for the application
  Future<void> setLocale(Locale locale) async {
    // This updates the internal state of slang for the core package.
    // According to slang docs, this should sync across packages if configured correctly,
    // but we can also manually sync in the UnifiedLocalizationProvider if needed.
    await LocaleSettings.setLocaleRaw(locale.languageCode);

    // Notify listeners
    _localeController.add(locale);
  }

  /// Get supported locales
  List<Locale> get supportedLocales => AppLocaleUtils.supportedLocales;
}
