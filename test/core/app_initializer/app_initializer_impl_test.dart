// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';

import 'package:core/core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';

/// Fake that records wall-clock start/end so we can assert concurrency.
class _TimedFakeInitializer implements AppInitializer {
  final String name;
  final Duration delay;
  final List<String> log;

  _TimedFakeInitializer({
    required this.name,
    required this.delay,
    required this.log,
  });

  @override
  Future<void> init() async {
    log.add('${name}_start');
    await Future<void>.delayed(delay);
    log.add('${name}_end');
  }
}

/// Fake that throws during init, to verify one failure doesn't abort others.
class _FailingInitializer implements AppInitializer {
  final List<String> log;
  _FailingInitializer(this.log);

  @override
  Future<void> init() async {
    log.add('failing_start');
    await Future<void>.delayed(const Duration(milliseconds: 10));
    throw Exception('intentional init failure');
  }
}

void main() {
  group('AppInitializerImpl', () {
    test('runs all initializers concurrently via Future.wait', () async {
      final log = <String>[];

      // A starts and takes 100ms; B starts and takes 10ms.
      // With Future.wait: B_end appears BEFORE A_end.
      // With sequential for-await: A_end appears BEFORE B_start.
      final impl = AppInitializerImpl([
        _TimedFakeInitializer(
          name: 'A',
          delay: const Duration(milliseconds: 100),
          log: log,
        ),
        _TimedFakeInitializer(
          name: 'B',
          delay: const Duration(milliseconds: 10),
          log: log,
        ),
      ]);

      await impl.init();

      // Concurrent: both start before either ends, B ends first.
      expect(log, containsAll(['A_start', 'B_start', 'A_end', 'B_end']));
      final bEndIdx = log.indexOf('B_end');
      final aEndIdx = log.indexOf('A_end');
      // B (10ms) should complete before A (100ms).
      expect(
        bEndIdx,
        lessThan(aEndIdx),
        reason: 'B should complete before A in concurrent mode',
      );
    });

    test('completes all initializers even when one throws', () async {
      final log = <String>[];

      final impl = AppInitializerImpl([
        _FailingInitializer(log),
        _TimedFakeInitializer(
          name: 'C',
          delay: const Duration(milliseconds: 5),
          log: log,
        ),
      ]);

      // Should NOT throw — failures are swallowed so startup is crash-free.
      await expectLater(impl.init(), completes);
      expect(
        log,
        contains('C_end'),
        reason: 'C must complete despite the failing initializer',
      );
    });
  });
}
