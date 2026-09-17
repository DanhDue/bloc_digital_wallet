// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter_test/flutter_test.dart';
import 'package:d3_nexus_shield/theme/app_theme_data.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('AppThemeData Static Cache Tests', () {
    test('lightTheme is configured with AppThemes.light tokens', () {
      final theme = AppThemeData.lightTheme;
      expect(theme.scaffoldBackgroundColor, equals(AppThemes.light.backgroundColor));
      expect(theme.colorScheme.primary, equals(AppThemes.light.primaryColor));
      expect(theme.colorScheme.secondary, equals(AppThemes.light.secondaryColor));
      expect(theme.colorScheme.surface, equals(AppThemes.light.surfaceColor));
      expect(theme.colorScheme.error, equals(AppThemes.light.errorColor));
      expect(theme.extension<AppThemes>(), equals(AppThemes.light));
    });

    test('darkTheme is configured with AppThemes.dark tokens', () {
      final theme = AppThemeData.darkTheme;
      expect(theme.scaffoldBackgroundColor, equals(AppThemes.dark.backgroundColor));
      expect(theme.colorScheme.primary, equals(AppThemes.dark.primaryColor));
      expect(theme.colorScheme.secondary, equals(AppThemes.dark.secondaryColor));
      expect(theme.colorScheme.surface, equals(AppThemes.dark.surfaceColor));
      expect(theme.colorScheme.error, equals(AppThemes.dark.errorColor));
      expect(theme.extension<AppThemes>(), equals(AppThemes.dark));
    });

    test('static instances are immutable singletons', () {
      expect(identical(AppThemeData.lightTheme, AppThemeData.lightTheme), isTrue);
      expect(identical(AppThemeData.darkTheme, AppThemeData.darkTheme), isTrue);
    });
  });
}
