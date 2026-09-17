// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:settings/presentation/settings/widgets/settings_section_widget.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('SettingsSectionWidget Unit & Widget Tests', () {
    testWidgets('encloses shadow container inside RepaintBoundary for GPU caching', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [AppThemes.light]),
          home: const Scaffold(
            body: SettingsSectionWidget(
              title: 'Account',
              children: [Text('Profile'), Text('Security')],
            ),
          ),
        ),
      );

      expect(find.text('ACCOUNT'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // Verify RepaintBoundary wraps the card container
      final repaintBoundaryFinder = find.descendant(
        of: find.byType(SettingsSectionWidget),
        matching: find.byType(RepaintBoundary),
      );
      expect(repaintBoundaryFinder, findsOneWidget);
    });
  });
}
