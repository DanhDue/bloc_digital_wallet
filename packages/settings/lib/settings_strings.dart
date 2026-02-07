// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'generated/translations.dart';

/// Wrapper for Settings translations to access them statically.
/// This updates automatically when the singleton locale changes.
class SettingsStrings {
  // Prevent instantiation
  SettingsStrings._();

  /// Get the current translations for Settings.
  ///
  /// Usage:
  /// ```dart
  /// Text(SettingsStrings.t.someText)
  /// ```
  static SettingsTranslations get t => LocaleSettings.instance.currentTranslations;
}
