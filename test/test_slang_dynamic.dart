// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/widgets.dart';
import 'package:core/generated/translations.dart' as core;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final json = {
    'core': {
      'common': {'error': 'Error Override'},
      'unknown_dynamic_key': 'This is totally dynamic!',
    },
    'totally_new_root_key': 'Root dynamic',
  };

  await core.LocaleSettings.overrideTranslationsFromMap(
    locale: core.CoreAppLocale.en,
    isFlatMap: false,
    map: json,
  );

  debugPrint('--- TEST DYNAMIC KEYS ---');
  debugPrint('core.common.error: ${core.coreT['core.common.error']}');
  debugPrint('core.unknown_dynamic_key: ${core.coreT['core.unknown_dynamic_key']}');
  debugPrint('totally_new_root_key: ${core.coreT['totally_new_root_key']}');
}
