// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart' hide test;
import 'package:d3_nexus_shield/core/app_initializer/localization_initializer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    D3NexusLogger.initialize(LogManagerImpl());
  });

  group('LocalizationInitializer', () {
    test('initializes default locale when no savedLanguageCode exists', () async {
      SharedPreferences.setMockInitialValues({});

      final initializer = LocalizationInitializer();
      await initializer.init();

      final currentLocale = LocalizationManager.instance.currentLocale;
      expect(currentLocale, isNotNull);
      expect(['en', 'vi'], contains(currentLocale.languageCode));
    });

    test('initializes saved locale when savedLanguageCode exists in SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({'saved_language_code': 'vi'});

      final initializer = LocalizationInitializer();
      await initializer.init();

      final currentLocale = LocalizationManager.instance.currentLocale;
      expect(currentLocale.languageCode, equals('vi'));
    });
  });
}
