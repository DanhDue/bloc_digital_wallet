// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:app_platform/platform.dart';
import 'package:core/core.dart' hide test;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:settings/domain/usecases/toggle_dark_mode_usecase.dart';

class MockAppEventBus extends Mock implements AppEventBus {}

class MockThemeManager extends Mock implements ThemeManager {}

/// ### BDD SCENARIOS
///
/// Feature: Settings Domain Orchestration Use Cases - ToggleDarkModeUseCase
///   As a digital wallet user
///   I want to toggle dark mode in settings
///   So that the application theme updates immediately and broadcasts ThemeModeChanged to AppEventBus
///
/// Scenario 1: Toggle dark mode to enabled (DARK)
///   Given ThemeManager and AppEventBus
///   When toggleDarkMode(isEnabled: true) is invoked
///   Then ThemeManager.setThemeMode is called with ThemeMode.dark
///   And ThemeModeChanged(isDarkMode: true) is published to AppEventBus
///
/// Scenario 2: Toggle dark mode to disabled (LIGHT)
///   Given ThemeManager and AppEventBus
///   When toggleDarkMode(isEnabled: false) is invoked
///   Then ThemeManager.setThemeMode is called with ThemeMode.light
///   And ThemeModeChanged(isDarkMode: false) is published to AppEventBus
void main() {
  late MockThemeManager mockThemeManager;
  late MockAppEventBus mockAppEventBus;
  late ToggleDarkModeUseCase useCase;

  setUpAll(() {
    registerFallbackValue(const ThemeModeChanged(isDarkMode: false));
  });

  setUp(() {
    mockThemeManager = MockThemeManager();
    mockAppEventBus = MockAppEventBus();
    useCase = ToggleDarkModeUseCase(mockThemeManager, mockAppEventBus);
  });

  group('ToggleDarkModeUseCase BDD / TDD Scenarios', () {
    test('Scenario 1: Toggle dark mode to enabled sets ThemeMode.dark and publishes ThemeModeChanged(true)', () async {
      when(() => mockThemeManager.setThemeMode(ThemeMode.dark))
          .thenAnswer((_) async {});
      when(() => mockAppEventBus.publish(any())).thenReturn(null);

      await useCase(isEnabled: true);

      verify(() => mockThemeManager.setThemeMode(ThemeMode.dark)).called(1);
      verify(() => mockAppEventBus.publish(const ThemeModeChanged(isDarkMode: true))).called(1);
    });

    test('Scenario 2: Toggle dark mode to disabled sets ThemeMode.light and publishes ThemeModeChanged(false)', () async {
      when(() => mockThemeManager.setThemeMode(ThemeMode.light))
          .thenAnswer((_) async {});
      when(() => mockAppEventBus.publish(any())).thenReturn(null);

      await useCase(isEnabled: false);

      verify(() => mockThemeManager.setThemeMode(ThemeMode.light)).called(1);
      verify(() => mockAppEventBus.publish(const ThemeModeChanged(isDarkMode: false))).called(1);
    });
  });
}
