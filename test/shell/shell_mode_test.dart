// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:d3_nexus_shield/shell/shell_config.dart';
import 'package:d3_nexus_shield/shell/shell_bloc.dart';
import 'package:d3_nexus_shield/shell/widgets/custom_bottom_nav_bar.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:d3_nexus_shield/generated/translations.dart';

void main() {
  setUpAll(() {
    LocaleSettings.setLocale(AppLocale.en);
  });

  group('Shell Mode & Config Tests', () {
    test('ShellConfig exposes valid tab count and default tab index', () {
      expect(ShellConfig.tabCount, isIn([2, 3]));
      expect(ShellConfig.defaultTabIndex, isIn([1, 2]));
      if (ShellConfig.tabCount == 3) {
        expect(ShellConfig.hasScannerTab, isTrue);
        expect(ShellConfig.defaultTabIndex, equals(2));
      } else {
        expect(ShellConfig.hasScannerTab, isFalse);
        expect(ShellConfig.defaultTabIndex, equals(1));
      }
    });

    test(
      'ShellBloc default currentTabIndex matches ShellConfig.defaultTabIndex',
      () {
        final bloc = ShellBloc();
        expect(bloc.state.currentTabIndex, equals(ShellConfig.defaultTabIndex));
      },
    );

    testWidgets(
      'CustomBottomNavBar renders appropriate items based on ShellConfig',
      (tester) async {
        await tester.pumpWidget(
          TranslationProvider(
            child: MaterialApp(
              theme: ThemeData(extensions: [AppThemes.light]),
              home: Scaffold(
                bottomNavigationBar: CustomBottomNavBar(
                  currentIndex: ShellConfig.defaultTabIndex,
                  onTap: (_) {},
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        expect(find.byKey(const ValueKey('settings_nav_tab')), findsOneWidget);

        if (ShellConfig.hasScannerTab) {
          expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
        } else {
          expect(find.byIcon(Icons.qr_code_scanner), findsNothing);
        }
      },
    );

    testWidgets(
      'CustomBottomNavBar isolates GPU shadow rasterization with RepaintBoundary',
      (tester) async {
        await tester.pumpWidget(
          TranslationProvider(
            child: MaterialApp(
              theme: ThemeData(extensions: [AppThemes.light]),
              home: Scaffold(
                bottomNavigationBar: CustomBottomNavBar(
                  currentIndex: ShellConfig.defaultTabIndex,
                  onTap: (_) {},
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final repaintBoundaries = find.descendant(
          of: find.byType(CustomBottomNavBar),
          matching: find.byType(RepaintBoundary),
        );
        expect(repaintBoundaries, findsAtLeast(1));
      },
    );
  });
}
