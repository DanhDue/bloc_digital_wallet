// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_digital_wallet/generated/translations.dart';
import 'package:core/core.dart' hide LocaleSettings, AppLocaleUtils;
import 'package:core/generated/translations.dart' as core;
import 'package:logger/d3nexus_logger.dart';
import 'package:authentication/generated/translations.dart' as auth;
import 'package:onboard/generated/translations.dart' as onboard;
import 'package:scanner/generated/translations.dart' as scanner;
import 'package:trends/generated/translations.dart' as trends;
import 'package:wallet/generated/translations.dart' as wallet;
import 'package:transaction/generated/translations.dart' as transaction;
import 'package:settings/generated/translations.dart' as settings;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:settings/domain/repositories/settings_repository.dart';
import 'package:bloc_digital_wallet/di/injection.dart';

class LocalizationInitializer implements AppInitializer {
  static final _logger = D3NexusLogger.getLogger('App');

  @override
  Future<void> init() async {
    // 1. Register sync callbacks so any locale change syncs to all packages
    _registerSyncLocaleCallback();

    // 2. Register override callback to apply dynamic JSON to all packages
    _registerOverrideCallback();

    // 3. Load saved locale and apply cached JSON
    await _loadSavedLocale();
  }

  void _registerSyncLocaleCallback() {
    LocalizationManager.instance.registerSyncLocaleCallback((locale) async {
      final rawLocale = locale.countryCode != null
          ? '${locale.languageCode}_${locale.countryCode}'
          : locale.languageCode;

      LocaleSettings.setLocaleRaw(rawLocale);
      auth.LocaleSettings.setLocaleRaw(rawLocale);
      onboard.LocaleSettings.setLocaleRaw(rawLocale);
      scanner.LocaleSettings.setLocaleRaw(rawLocale);
      trends.LocaleSettings.setLocaleRaw(rawLocale);
      wallet.LocaleSettings.setLocaleRaw(rawLocale);
      transaction.LocaleSettings.setLocaleRaw(rawLocale);
      settings.LocaleSettings.setLocaleRaw(rawLocale);
    });
  }

  void _registerOverrideCallback() {
    LocalizationManager.instance.registerOverrideCallback((json, locale) async {
      final rawLocale = locale.countryCode != null
          ? '${locale.languageCode}_${locale.countryCode}'
          : locale.languageCode;

      // Root
      await LocaleSettings.overrideTranslationsFromMap(
        locale: AppLocaleUtils.parse(rawLocale),
        isFlatMap: false,
        map: json,
      );
      // Feature packages
      await core.LocaleSettings.overrideTranslationsFromMap(
        locale: core.AppLocaleUtils.parse(rawLocale),
        isFlatMap: false,
        map: {'core': json['core'] ?? {}},
      );
      await auth.LocaleSettings.overrideTranslationsFromMap(
        locale: auth.AppLocaleUtils.parse(rawLocale),
        isFlatMap: false,
        map: {'authentication': json['authentication'] ?? {}},
      );
      await onboard.LocaleSettings.overrideTranslationsFromMap(
        locale: onboard.AppLocaleUtils.parse(rawLocale),
        isFlatMap: false,
        map: {'onboard': json['onboard'] ?? {}},
      );
      await scanner.LocaleSettings.overrideTranslationsFromMap(
        locale: scanner.AppLocaleUtils.parse(rawLocale),
        isFlatMap: false,
        map: {'scanner': json['scanner'] ?? {}},
      );
      await trends.LocaleSettings.overrideTranslationsFromMap(
        locale: trends.AppLocaleUtils.parse(rawLocale),
        isFlatMap: false,
        map: {'trends': json['trends'] ?? {}},
      );
      await wallet.LocaleSettings.overrideTranslationsFromMap(
        locale: wallet.AppLocaleUtils.parse(rawLocale),
        isFlatMap: false,
        map: {'wallet': json['wallet'] ?? {}},
      );
      await transaction.LocaleSettings.overrideTranslationsFromMap(
        locale: transaction.AppLocaleUtils.parse(rawLocale),
        isFlatMap: false,
        map: {'transaction': json['transaction'] ?? {}},
      );
      await settings.LocaleSettings.overrideTranslationsFromMap(
        locale: settings.AppLocaleUtils.parse(rawLocale),
        isFlatMap: false,
        map: {'settings': json['settings'] ?? {}},
      );
    });
  }

  Future<void> _loadSavedLocale() async {
    _logger.d('LocalizationInitializer._loadSavedLocale: Starting');
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString('saved_language_code');

    if (savedLanguageCode != null) {
      _logger.d(
        'LocalizationInitializer._loadSavedLocale: savedLanguageCode = $savedLanguageCode',
      );
      await LocalizationManager.instance.setLocaleFromCode(savedLanguageCode);

      // Load cached dynamic translations if available
      try {
        final settingsRepo = getIt<SettingsRepository>();
        final jsonResult = await settingsRepo.getCachedTranslationJson(savedLanguageCode);
        if (jsonResult.isRight()) {
          final json = jsonResult.getOrElse(() => null);
          if (json != null) {
            _logger.d(
              'LocalizationInitializer._loadSavedLocale: Found cached JSON, applying dynamic translations',
            );
            await LocalizationManager.instance.applyDynamicTranslations(
              json,
              targetLanguageCode: savedLanguageCode,
            );
          } else {
            _logger.d('LocalizationInitializer._loadSavedLocale: Cached JSON is null');
          }
        } else {
          _logger.d(
            'LocalizationInitializer._loadSavedLocale: getCachedTranslationJson returned Left',
          );
        }
      } catch (e, st) {
        _logger.e(
          'LocalizationInitializer._loadSavedLocale: Error applying dynamic translations',
          error: e,
          stackTrace: st,
        );
      }
    } else {
      _logger.d(
        'LocalizationInitializer._loadSavedLocale: No savedLanguageCode found, using default locale',
      );
      // Initialize slang translations fallback
      LocaleSettings.useDeviceLocale();
      // Ensure sync runs even for device locale
      final currentRaw = LocaleSettings.currentLocale.languageTag;
      await LocalizationManager.instance.setLocaleFromCode(currentRaw);
    }
  }
}
