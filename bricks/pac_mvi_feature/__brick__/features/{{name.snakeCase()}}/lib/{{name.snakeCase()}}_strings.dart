// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'generated/translations.dart';

/// Wrapper for {{name.pascalCase()}} translations to access them statically.
/// This updates automatically when the singleton locale changes.
class {{name.pascalCase()}}Strings {
  // Prevent instantiation
  {{name.pascalCase()}}Strings._();

  /// Get the current translations for {{name.pascalCase()}}.
  ///
  /// Usage:
  /// ```dart
  /// Text({{name.pascalCase()}}Strings.t.someText)
  /// ```
  static {{name.pascalCase()}}Translations get t => LocaleSettings.instance.currentTranslations;
}
