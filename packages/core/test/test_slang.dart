// ignore_for_file: avoid_print, unnecessary_cast
// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    print('Testing ko_KR...');
    final locale = await LocaleSettings.setLocaleRaw('ko_KR');
    print('Result: $locale');
  } catch (e, s) {
    print('EXCEPTION: $e');
    print(s);
  }
}
