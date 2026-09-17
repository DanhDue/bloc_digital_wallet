// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:d3_nexus_shield/shell/home_dashboard_page.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('HomeDashboardPage Tests', () {
    testWidgets(
      'HomeDashboardPage does NOT wrap content in a nested Scaffold',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [AppThemes.light]),
            home: const Scaffold(body: HomeDashboardPage()),
          ),
        );
        await tester.pumpAndSettle();

        // Exactly one outer Scaffold in the whole tree, none inside HomeDashboardPage
        expect(find.byType(Scaffold), findsOneWidget);
        final innerScaffolds = find.descendant(
          of: find.byType(HomeDashboardPage),
          matching: find.byType(Scaffold),
        );
        expect(innerScaffolds, findsNothing);
      },
    );

    testWidgets('HomeDashboardPage renders header, icon, and description texts', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [AppThemes.light]),
          home: const Scaffold(body: HomeDashboardPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Super App'), findsOneWidget);
      expect(find.text('Super App Template'), findsOneWidget);
      expect(
        find.text('Modular Clean Architecture + MVI for Flutter'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.dashboard_customize_outlined), findsOneWidget);
    });
  });
}
