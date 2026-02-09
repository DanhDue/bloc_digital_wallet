// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'generated/translations.dart';

/// Wrapper for Home translations to access them statically.
/// This updates automatically when the singleton locale changes.
class HomeStrings {
  // Prevent instantiation
  HomeStrings._();

  /// Get the current translations for Home.
  ///
  /// Usage:
  /// ```dart
  /// Text(HomeStrings.t.someText)
  /// ```
  static HomeTranslations get t => LocaleSettings.instance.currentTranslations;
}
