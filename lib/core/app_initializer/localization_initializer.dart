// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_digital_wallet/generated/translations.dart';
import 'package:core/core.dart' hide LocaleSettings, AppLocaleUtils;
import 'package:core/generated/translations.dart' as core;
import 'package:authentication/generated/translations.dart' as auth;
import 'package:onboard/generated/translations.dart' as onboard;
import 'package:home/generated/translations.dart' as home;
import 'package:scanner/generated/translations.dart' as scanner;
import 'package:trends/generated/translations.dart' as trends;
import 'package:wallet/generated/translations.dart' as wallet;
import 'package:transaction/generated/translations.dart' as transaction;
import 'package:settings/generated/translations.dart' as settings;

class LocalizationInitializer implements AppInitializer {
  @override
  Future<void> init() async {
    // Initialize slang translations
    LocaleSettings.useDeviceLocale();

    LocalizationManager.instance.registerOverrideCallback((json, locale) async {
      final languageCode = locale.languageCode;
      // Root
      await LocaleSettings.overrideTranslationsFromMap(
        locale: AppLocaleUtils.parse(languageCode),
        isFlatMap: false,
        map: json,
      );
      // Feature packages
      await core.LocaleSettings.overrideTranslationsFromMap(
        locale: core.AppLocaleUtils.parse(languageCode),
        isFlatMap: false,
        map: json['core'] ?? {},
      );
      await auth.LocaleSettings.overrideTranslationsFromMap(
        locale: auth.AppLocaleUtils.parse(languageCode),
        isFlatMap: false,
        map: json['authentication'] ?? {},
      );
      await onboard.LocaleSettings.overrideTranslationsFromMap(
        locale: onboard.AppLocaleUtils.parse(languageCode),
        isFlatMap: false,
        map: json['onboard'] ?? {},
      );
      await home.LocaleSettings.overrideTranslationsFromMap(
        locale: home.AppLocaleUtils.parse(languageCode),
        isFlatMap: false,
        map: json['home'] ?? {},
      );
      await scanner.LocaleSettings.overrideTranslationsFromMap(
        locale: scanner.AppLocaleUtils.parse(languageCode),
        isFlatMap: false,
        map: json['scanner'] ?? {},
      );
      await trends.LocaleSettings.overrideTranslationsFromMap(
        locale: trends.AppLocaleUtils.parse(languageCode),
        isFlatMap: false,
        map: json['trends'] ?? {},
      );
      await wallet.LocaleSettings.overrideTranslationsFromMap(
        locale: wallet.AppLocaleUtils.parse(languageCode),
        isFlatMap: false,
        map: json['wallet'] ?? {},
      );
      await transaction.LocaleSettings.overrideTranslationsFromMap(
        locale: transaction.AppLocaleUtils.parse(languageCode),
        isFlatMap: false,
        map: json['transaction'] ?? {},
      );
      await settings.LocaleSettings.overrideTranslationsFromMap(
        locale: settings.AppLocaleUtils.parse(languageCode),
        isFlatMap: false,
        map: json['settings'] ?? {},
      );
    });
  }
}
