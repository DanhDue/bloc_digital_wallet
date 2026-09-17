// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter_test/flutter_test.dart';
import 'package:native_security/native_security.dart';

void main() {
  group('NativeSecurity Tests', () {
    test('getAllowedFingerprints executes or throws UnsupportedError in host env', () {
      try {
        final fingerprints = NativeSecurity.getAllowedFingerprints();
        expect(fingerprints, isA<List<String>>());
      } on UnsupportedError catch (e) {
        expect(e.message, isNotEmpty);
      }
    });
  });
}
