// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter_test/flutter_test.dart';
import 'package:core/utils/checksum_utils.dart';

void main() {
  group('ChecksumUtils', () {
    test('computeSha256 returns identical hash for reordered keys', () {
      final json1 = {
        'a': 1,
        'b': {'d': 3, 'c': 2},
      };
      final json2 = {
        'b': {'c': 2, 'd': 3},
        'a': 1,
      };

      final hash1 = ChecksumUtils.computeSha256(json1);
      final hash2 = ChecksumUtils.computeSha256(json2);

      expect(hash1, hash2);
    });
  });
}
