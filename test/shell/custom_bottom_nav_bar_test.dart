// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:d3_nexus_shield/shell/widgets/custom_bottom_nav_bar.dart';
import 'package:d3_nexus_shield/generated/translations.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  setUpAll(() {
    LocaleSettings.setLocale(AppLocale.en);
  });

  group('CustomBottomNavBar Staged Shadow Rendering Tests', () {
    testWidgets('Frame 0 renders flat container without BoxShadow, Frame 1 enables BoxShadow', (
      tester,
    ) async {
      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            theme: ThemeData(extensions: [AppThemes.light]),
            home: Scaffold(
              bottomNavigationBar: CustomBottomNavBar(currentIndex: 0, onTap: (_) {}),
            ),
          ),
        ),
      );

      // Frame 0 only (do not pumpAndSettle yet)
      final outerContainerFinder = find
          .descendant(of: find.byType(CustomBottomNavBar), matching: find.byType(Container))
          .first;

      final Container initialContainer = tester.widget<Container>(outerContainerFinder);
      final initialBoxDecoration = initialContainer.decoration as BoxDecoration;
      // In two-stage rendering, Frame 0 should have no shadow
      expect(initialBoxDecoration.boxShadow, isNull);

      // Now settle frame 1 (post-frame callback execution)
      await tester.pumpAndSettle();

      final Container settledContainer = tester.widget<Container>(outerContainerFinder);
      final settledBoxDecoration = settledContainer.decoration as BoxDecoration;
      expect(settledBoxDecoration.boxShadow, isNotNull);
      expect(settledBoxDecoration.boxShadow!.first.blurRadius, equals(10));
    });

    testWidgets('Tapping tab works cleanly during Frame 0', (tester) async {
      int? tappedIndex;

      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            theme: ThemeData(extensions: [AppThemes.light]),
            home: Scaffold(
              bottomNavigationBar: CustomBottomNavBar(
                currentIndex: 0,
                onTap: (index) {
                  tappedIndex = index;
                },
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Tap on Home tab
      await tester.tap(find.text('Home'));
      await tester.pump(const Duration(milliseconds: 350));
      expect(tappedIndex, equals(ShellTabIndex.home));

      await tester.pumpAndSettle();
    });
  });
}
