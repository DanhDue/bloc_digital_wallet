// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:d3_nexus_shield/generated/translations.dart' as root;
import 'package:flutter/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    debugPrint('Testing Slang Exception...');
    final json = {
      'success': true,
      'data': {
        'settings': {'title': '설정'},
      },
    };

    final languageCode = 'ko_KR';

    await root.LocaleSettings.overrideTranslationsFromMap(
      locale: root.AppLocaleUtils.parse(languageCode),
      isFlatMap: false,
      map: json,
    );
    debugPrint('SUCCESS');
  } catch (e, s) {
    debugPrint('EXCEPTION: $e, ${s.toString()}');
  }
}
