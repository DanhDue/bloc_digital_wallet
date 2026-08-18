// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:convert';
import 'package:crypto/crypto.dart';

class ChecksumUtils {
  /// Computes the SHA-256 digest of a JSON map.
  /// To ensure determinism, keys are recursively sorted.
  static String computeSha256(Map<String, dynamic> jsonMap) {
    final sortedMap = _sortMapKeys(jsonMap);
    final jsonString = jsonEncode(sortedMap);
    final bytes = utf8.encode(jsonString);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static dynamic _sortMapKeys(dynamic value) {
    if (value is Map<String, dynamic>) {
      final sortedMap = <String, dynamic>{};
      final sortedKeys = value.keys.toList()..sort();
      for (final key in sortedKeys) {
        sortedMap[key] = _sortMapKeys(value[key]);
      }
      return sortedMap;
    } else if (value is Map) {
      final sortedMap = <String, dynamic>{};
      final sortedKeys = value.keys.map((e) => e.toString()).toList()..sort();
      for (final key in sortedKeys) {
        sortedMap[key] = _sortMapKeys(value[key]);
      }
      return sortedMap;
    } else if (value is List) {
      return value.map(_sortMapKeys).toList();
    }
    return value;
  }
}
