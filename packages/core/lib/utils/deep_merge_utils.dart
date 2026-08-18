// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

class DeepMergeUtils {
  /// Recursively merges [changes] into [base].
  static Map<String, dynamic> deepMerge(Map<String, dynamic> base, Map<String, dynamic> changes) {
    final result = Map<String, dynamic>.from(base);
    for (final key in changes.keys) {
      if (changes[key] is Map<String, dynamic> && result[key] is Map<String, dynamic>) {
        result[key] = deepMerge(
          result[key] as Map<String, dynamic>,
          changes[key] as Map<String, dynamic>,
        );
      } else {
        result[key] = changes[key];
      }
    }
    return result;
  }

  /// Removes keys specified in [deletedKeys] from [source].
  /// [deletedKeys] should be a list of dot-separated paths (e.g., "common.appName").
  static Map<String, dynamic> deleteKeys(Map<String, dynamic> source, List<String> deletedKeys) {
    final result = Map<String, dynamic>.from(source);
    for (final path in deletedKeys) {
      _deletePath(result, path.split('.'));
    }
    return result;
  }

  static void _deletePath(Map<String, dynamic> map, List<String> pathParts) {
    if (pathParts.isEmpty) return;
    if (pathParts.length == 1) {
      map.remove(pathParts.first);
      return;
    }
    final key = pathParts.first;
    if (map[key] is Map<String, dynamic>) {
      _deletePath(map[key] as Map<String, dynamic>, pathParts.sublist(1));
    }
  }
}
