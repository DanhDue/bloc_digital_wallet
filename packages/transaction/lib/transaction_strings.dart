// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'generated/translations.dart';

/// Wrapper for Transaction translations to access them statically.
/// This updates automatically when the singleton locale changes.
class TransactionStrings {
  // Prevent instantiation
  TransactionStrings._();

  /// Get the current translations for Transaction.
  ///
  /// Usage:
  /// ```dart
  /// Text(TransactionStrings.t.someText)
  /// ```
  static TransactionTranslations get t => LocaleSettings.instance.currentTranslations;
}
