// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter_test/flutter_test.dart';
import 'package:d3_nexus_shield/app_router.dart';
import 'package:d3_nexus_shield/shell/shell_config.dart';

void main() {
  group('AppRouter Mode Tests', () {
    test('routes list contains Home and Settings routes', () {
      final router = AppRouter();
      final paths = router.routes.map((r) => r.path).toList();

      expect(paths, contains(AppRoutes.home));
      expect(paths, contains(AppRoutes.settings));
    });

    test('scanner route matches ShellConfig hasScannerTab presence', () {
      final router = AppRouter();
      final paths = router.routes.map((r) => r.path).toList();

      if (ShellConfig.hasScannerTab) {
        expect(paths, contains(AppRoutes.scanner));
      } else {
        expect(paths, isNot(contains(AppRoutes.scanner)));
      }
    });
  });
}
