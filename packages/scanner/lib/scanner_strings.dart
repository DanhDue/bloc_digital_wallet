// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'generated/translations.dart';

/// Wrapper for Scanner translations to access them statically.
/// This updates automatically when the singleton locale changes.
class ScannerStrings {
  // Prevent instantiation
  ScannerStrings._();

  /// Get the current translations for Scanner.
  ///
  /// Usage:
  /// ```dart
  /// Text(ScannerStrings.t.someText)
  /// ```
  static ScannerTranslations get t => LocaleSettings.instance.currentTranslations;
}
