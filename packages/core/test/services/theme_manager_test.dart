// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/services/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ThemeManager BDD / TDD Scenarios', () {
    test('Scenario 1: First init without cached preference defaults to system mode', () async {
      SharedPreferences.setMockInitialValues({});
      final manager = ThemeManager.instance;
      await manager.init();

      expect(manager.currentThemeMode, ThemeMode.system);
      expect(manager.hasUserExplicitPreference, isFalse);
    });

    test('Scenario 2: isDarkMode evaluates effective brightness in system mode', () async {
      SharedPreferences.setMockInitialValues({});
      final manager = ThemeManager.instance;
      await manager.init();

      expect(manager.currentThemeMode, ThemeMode.system);
      // In flutter_test, platformDispatcher.platformBrightness defaults to Brightness.light
      expect(
        manager.isDarkMode,
        WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark,
      );
    });

    test(
      'Scenario 3: Calling setThemeMode marks explicit preference and persists to disk',
      () async {
        SharedPreferences.setMockInitialValues({});
        final manager = ThemeManager.instance;
        await manager.init();

        await manager.setThemeMode(ThemeMode.dark);

        expect(manager.currentThemeMode, ThemeMode.dark);
        expect(manager.hasUserExplicitPreference, isTrue);
        expect(manager.isDarkMode, isTrue);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getInt('app_theme_mode'), ThemeMode.dark.index);
      },
    );

    test('Scenario 4: Re-init with existing preference restores explicit choice', () async {
      SharedPreferences.setMockInitialValues({'app_theme_mode': ThemeMode.light.index});
      final manager = ThemeManager.instance;
      await manager.init();

      expect(manager.currentThemeMode, ThemeMode.light);
      expect(manager.hasUserExplicitPreference, isTrue);
      expect(manager.isDarkMode, isFalse);
    });

    test('Scenario 5: didChangePlatformBrightness notifies stream when in system mode', () async {
      SharedPreferences.setMockInitialValues({});
      final manager = ThemeManager.instance;
      await manager.init();

      expect(manager.hasUserExplicitPreference, isFalse);

      final emissions = <ThemeMode>[];
      final sub = manager.themeModeStream.listen(emissions.add);

      manager.didChangePlatformBrightness();
      await Future<void>.delayed(Duration.zero);

      expect(emissions, contains(ThemeMode.system));
      await sub.cancel();
    });

    test('Scenario 6: Out of bounds preference index safely falls back to system mode', () async {
      SharedPreferences.setMockInitialValues({'app_theme_mode': 999});
      final manager = ThemeManager.instance;
      await manager.init();

      expect(manager.currentThemeMode, ThemeMode.system);
      expect(manager.hasUserExplicitPreference, isFalse);
    });
  });
}
