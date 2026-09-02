// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

/// A utility class for directly looking up dynamic keys from the API (e.g., Enum statuses from the server)
/// that were not declared in Slang at compile time.
///
/// **Usage Guide:**
///
/// Suppose the server returns a transaction status enum as `COMPLETED`.
/// You want to get the corresponding translated string from the key `transaction.status.COMPLETED`.
/// However, this key might be added later via the Dynamic Configuration system,
/// so Slang cannot generate the `t.transaction.status.COMPLETED` property in advance.
///
/// Instead, you use `DynamicTranslator` like this:
///
/// ```dart
/// // stringKey could be "transaction.status.COMPLETED" (received dynamically from API)
/// final translatedStr = DynamicTranslator.translate('transaction.status.COMPLETED');
///
/// // If not found in the dynamic dictionary, the function will return the exact key "transaction.status.COMPLETED"
/// ```
class DynamicTranslator {
  static Map<String, dynamic> _rawTranslations = {};

  /// Updates the dynamic dictionary. This function is called automatically inside
  /// [LocalizationManager.applyDynamicTranslations], you do not need to call it manually.
  static void updateJson(Map<String, dynamic> json) {
    _rawTranslations = json;
  }

  /// Looks up a completely free-form key from the server.
  /// Supports nested keys (e.g., "status.warning.scam")
  static String translate(String key) {
    if (key.isEmpty) return key;

    final parts = key.split('.');
    dynamic current = _rawTranslations;

    for (final part in parts) {
      if (current is Map && current.containsKey(part)) {
        current = current[part];
      } else {
        return key; // Fallback: Return the key itself if not found
      }
    }

    return current?.toString() ?? key;
  }
}
