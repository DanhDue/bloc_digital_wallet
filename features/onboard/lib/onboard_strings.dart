// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'generated/translations.dart';

/// Wrapper for Onboard translations to access them statically.
/// This updates automatically when the singleton locale changes.
class OnboardStrings {
  // Prevent instantiation
  OnboardStrings._();

  /// Get the current translations for Onboard.
  ///
  /// Usage:
  /// ```dart
  /// Text(OnboardStrings.t.splashTitle)
  /// ```
  static OnboardTranslations get t => LocaleSettings.instance.currentTranslations;
}
