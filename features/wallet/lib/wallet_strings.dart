// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'generated/translations.dart';

/// Wrapper for Wallet translations to access them statically.
/// This updates automatically when the singleton locale changes.
class WalletStrings {
  // Prevent instantiation
  WalletStrings._();

  /// Get the current translations for Wallet.
  ///
  /// Usage:
  /// ```dart
  /// Text(WalletStrings.t.someText)
  /// ```
  static WalletTranslations get t => LocaleSettings.instance.currentTranslations;
}
