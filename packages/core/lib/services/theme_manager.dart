// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with WidgetsBindingObserver {
  static const String _themeKey = 'app_theme_mode';

  ThemeManager._();
  static final ThemeManager instance = ThemeManager._();

  final BehaviorSubject<ThemeMode> _themeModeSubject = BehaviorSubject<ThemeMode>.seeded(
    ThemeMode.system,
  );

  bool _hasUserExplicitPreference = false;
  bool _isObserverRegistered = false;

  Stream<ThemeMode> get themeModeStream => _themeModeSubject.stream;
  ThemeMode get currentThemeMode => _themeModeSubject.value;
  bool get hasUserExplicitPreference => _hasUserExplicitPreference;

  /// Returns whether effective theme is dark:
  /// - When in [ThemeMode.system], dynamically inspects [platformBrightness].
  /// - Otherwise, checks if [currentThemeMode] is [ThemeMode.dark].
  bool get isDarkMode {
    if (currentThemeMode == ThemeMode.system) {
      final binding = WidgetsBinding.instance;
      return binding.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return currentThemeMode == ThemeMode.dark;
  }

  Future<void> init() async {
    _registerObserver();
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey);
    if (themeIndex != null && themeIndex >= 0 && themeIndex < ThemeMode.values.length) {
      _hasUserExplicitPreference = true;
      _themeModeSubject.add(ThemeMode.values[themeIndex]);
    } else {
      _hasUserExplicitPreference = false;
      _themeModeSubject.add(ThemeMode.system);
    }
  }

  void _registerObserver() {
    if (!_isObserverRegistered) {
      WidgetsBinding.instance.addObserver(this);
      _isObserverRegistered = true;
    }
  }

  @override
  void didChangePlatformBrightness() {
    if (!_hasUserExplicitPreference && !_themeModeSubject.isClosed) {
      _themeModeSubject.add(ThemeMode.system);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _hasUserExplicitPreference = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
    _themeModeSubject.add(mode);
  }

  void dispose() {
    if (_isObserverRegistered) {
      WidgetsBinding.instance.removeObserver(this);
      _isObserverRegistered = false;
    }
    _themeModeSubject.close();
  }
}
