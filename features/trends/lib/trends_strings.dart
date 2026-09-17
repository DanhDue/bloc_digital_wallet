// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'generated/translations.dart';

/// Wrapper for Trends translations to access them statically.
/// This updates automatically when the singleton locale changes.
class TrendsStrings {
  // Prevent instantiation
  TrendsStrings._();

  /// Get the current translations for Trends.
  ///
  /// Usage:
  /// ```dart
  /// Text(TrendsStrings.l10n.trendsSearchHint)
  /// ```
  static TrendsTranslations get l10n => LocaleSettings.instance.currentTranslations;

  /// Alias for [l10n] for convenience.
  static TrendsTranslations get t => l10n;
}
