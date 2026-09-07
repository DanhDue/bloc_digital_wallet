// ignore_for_file: avoid_print, unnecessary_cast
// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:d3_nexus_shield/generated/translations.dart' as root;
import 'package:core/generated/translations.dart' as core;
import 'package:flutter/widgets.dart';
import 'package:settings/generated/translations.dart' as settings;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final json = {
      'core': {},
      'settings': {'title': '설정'},
    };

    final languageCode = 'ko_KR';

    print('Testing ROOT override');
    await root.LocaleSettings.overrideTranslationsFromMap(
      locale: root.AppLocaleUtils.parse(languageCode),
      isFlatMap: false,
      map: json,
    );

    print('Testing CORE override');
    await core.LocaleSettings.overrideTranslationsFromMap(
      locale: core.AppLocaleUtils.parse(languageCode),
      isFlatMap: false,
      map: json['core'] as Map<dynamic, dynamic>? ?? {},
    );

    print('Testing SETTINGS override');
    await settings.LocaleSettings.overrideTranslationsFromMap(
      locale: settings.AppLocaleUtils.parse(languageCode),
      isFlatMap: false,
      map: json['settings'] as Map<dynamic, dynamic>? ?? {},
    );

    print('ALL SUCCESS');
  } catch (e, s) {
    print('EXCEPTION: $e');
    print(s);
  }
}
