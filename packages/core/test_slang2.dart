// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

// ignore_for_file: avoid_print, unnecessary_cast
import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    debugPrint('Testing ko_KR override...');
    final json = {
      'core': {'ok': '오케이'},
      'settings': {'title': '설정'},
    };

    // Simulate what the initializer does
    final languageCode = 'ko_KR';
    final locale = AppLocaleUtils.parse(languageCode);
    debugPrint('Parsed locale: $locale');

    await LocaleSettings.overrideTranslationsFromMap(locale: locale, isFlatMap: false, map: json);
    debugPrint('Root override success');
  } catch (e, s) {
    debugPrint('EXCEPTION: $e');
    debugPrint(s.toString());
  }
}
