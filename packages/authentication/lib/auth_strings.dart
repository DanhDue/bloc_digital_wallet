// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'generated/translations.dart';

/// Wrapper for Authentication translations to access them statically.
/// This updates automatically when the singleton locale changes.
class AuthStrings {
  // Prevent instantiation
  AuthStrings._();

  /// Get the current translations for Authentication.
  ///
  /// Usage:
  /// ```dart
  /// Text(AuthStrings.t.loginTitle)
  /// ```
  static AuthTranslations get t => LocaleSettings.instance.currentTranslations;
}
