// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';

// Kept in its own test file (its own isolate) so D3NexusLogger's static
// state is guaranteed to still be uninitialized here, regardless of what
// other test files do with D3NexusLogger.initialize().
void main() {
  test('D3NexusLogger.getLogger throws if used before initialize()', () {
    expect(() => D3NexusLogger.getLogger('wallet'), throwsA(isA<StateError>()));
  });

  test('D3NexusLogger.setModuleEnabled throws if used before initialize()', () {
    expect(() => D3NexusLogger.setModuleEnabled('wallet', false), throwsA(isA<StateError>()));
  });

  test('D3NexusLogger.setAppenderEnabled throws if used before initialize()', () {
    expect(() => D3NexusLogger.setAppenderEnabled('console', false), throwsA(isA<StateError>()));
  });
}
