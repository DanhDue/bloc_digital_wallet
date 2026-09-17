// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Pre-configured, immutable [ThemeData] singletons to avoid runtime allocation
/// during build passes on cold start and stream updates.
class AppThemeData {
  const AppThemeData._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppThemes.light.backgroundColor,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    hoverColor: Colors.transparent,
    extensions: [AppThemes.light],
    colorScheme: ColorScheme.light(
      primary: AppThemes.light.primaryColor,
      secondary: AppThemes.light.secondaryColor,
      surface: AppThemes.light.surfaceColor,
      error: AppThemes.light.errorColor,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppThemes.dark.backgroundColor,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    hoverColor: Colors.transparent,
    extensions: [AppThemes.dark],
    colorScheme: ColorScheme.dark(
      primary: AppThemes.dark.primaryColor,
      secondary: AppThemes.dark.secondaryColor,
      surface: AppThemes.dark.surfaceColor,
      error: AppThemes.dark.errorColor,
    ),
  );
}
