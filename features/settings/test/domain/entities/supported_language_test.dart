// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter_test/flutter_test.dart';
import 'package:settings/domain/entities/supported_language.dart';

void main() {
  group('SupportedLanguage', () {
    test('supports value equality', () {
      const lang1 = SupportedLanguage(
        languageCode: 'en',
        languageName: 'English',
        isDefault: true,
        isActive: true,
        isCached: true,
      );
      const lang2 = SupportedLanguage(
        languageCode: 'en',
        languageName: 'English',
        isDefault: true,
        isActive: true,
        isCached: true,
      );

      expect(lang1, equals(lang2));
      expect(lang1.props, equals(['en', 'English', null, true, true, true]));
    });

    test('default property values', () {
      const lang = SupportedLanguage(languageCode: 'ja', languageName: 'Japanese');

      expect(lang.isDefault, isFalse);
      expect(lang.isActive, isTrue);
      expect(lang.isCached, isFalse);
      expect(lang.version, isNull);
    });

    test('copyWith works correctly', () {
      const lang = SupportedLanguage(languageCode: 'en', languageName: 'English');

      final updated = lang.copyWith(isCached: true, version: '1.0.0');

      expect(updated.isCached, isTrue);
      expect(updated.version, equals('1.0.0'));
      expect(updated.languageCode, equals('en'));
    });
  });
}
