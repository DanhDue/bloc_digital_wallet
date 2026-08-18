// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  static const String _themeKey = 'app_theme_mode';

  ThemeManager._();
  static final ThemeManager instance = ThemeManager._();

  final BehaviorSubject<ThemeMode> _themeModeSubject =
      BehaviorSubject<ThemeMode>.seeded(ThemeMode.system);

  Stream<ThemeMode> get themeModeStream => _themeModeSubject.stream;
  ThemeMode get currentThemeMode => _themeModeSubject.value;
  bool get isDarkMode => currentThemeMode == ThemeMode.dark;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey);
    if (themeIndex != null) {
      _themeModeSubject.add(ThemeMode.values[themeIndex]);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
    _themeModeSubject.add(mode);
  }

  void dispose() {
    _themeModeSubject.close();
  }
}
