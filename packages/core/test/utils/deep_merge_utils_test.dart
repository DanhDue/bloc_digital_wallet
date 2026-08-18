// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter_test/flutter_test.dart';
import 'package:core/utils/deep_merge_utils.dart';

void main() {
  group('DeepMergeUtils', () {
    test('deepMerge correctly merges nested maps', () {
      final base = {
        'a': 1,
        'b': {'c': 2, 'd': 3},
      };
      final changes = {
        'b': {'c': 4, 'e': 5},
        'f': 6,
      };

      final merged = DeepMergeUtils.deepMerge(base, changes);

      expect(merged, {
        'a': 1,
        'b': {'c': 4, 'd': 3, 'e': 5},
        'f': 6,
      });
    });

    test('deleteKeys removes keys by path', () {
      final source = {
        'a': 1,
        'b': {'c': 2, 'd': 3},
        'e': {
          'f': {'g': 4},
        },
      };

      final deleted = DeepMergeUtils.deleteKeys(source, ['a', 'b.c', 'e.f.g']);

      expect(deleted, {
        'b': {'d': 3},
        'e': {'f': {}},
      });
    });
  });
}
