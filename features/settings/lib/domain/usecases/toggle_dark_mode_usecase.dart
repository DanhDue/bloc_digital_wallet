// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:app_platform/platform.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class ToggleDarkModeUseCase {
  final ThemeManager _themeManager;
  final AppEventBus _appEventBus;

  ToggleDarkModeUseCase(this._themeManager, this._appEventBus);

  Future<void> call({required bool isEnabled}) async {
    final mode = isEnabled ? ThemeMode.dark : ThemeMode.light;
    await _themeManager.setThemeMode(mode);
    _appEventBus.publish(ThemeModeChanged(isDarkMode: isEnabled));
  }
}
