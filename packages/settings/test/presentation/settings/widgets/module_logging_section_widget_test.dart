// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:settings/presentation/settings/models/logging_toggle_constants.dart';
import 'package:settings/presentation/settings/widgets/module_logging_section_widget.dart';

void main() {
  Future<void> pumpSection(
    WidgetTester tester, {
    required Map<String, bool> moduleToggles,
    required void Function(String module, bool isEnabled) onToggle,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ModuleLoggingSectionWidget(
              title: 'Module Logging',
              moduleToggles: moduleToggles,
              onToggle: onToggle,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('renders one row per known logging module', (tester) async {
    await pumpSection(tester, moduleToggles: const {}, onToggle: (_, _) {});

    for (final module in kKnownLoggingModules) {
      expect(find.text(module), findsOneWidget);
    }
    expect(find.byType(CupertinoSwitch), findsNWidgets(kKnownLoggingModules.length));
  });

  testWidgets('a module absent from the toggle map renders as enabled', (tester) async {
    await pumpSection(tester, moduleToggles: const {}, onToggle: (_, _) {});

    final switchFinder = find.descendant(
      of: find.byKey(ValueKey('module_logging_toggle_${kKnownLoggingModules.first}')),
      matching: find.byType(CupertinoSwitch),
    );
    final CupertinoSwitch widget = tester.widget(switchFinder);
    expect(widget.value, isTrue);
  });

  testWidgets('a module with an explicit false override renders as disabled', (tester) async {
    final module = kKnownLoggingModules.first;
    await pumpSection(tester, moduleToggles: {module: false}, onToggle: (_, _) {});

    final switchFinder = find.descendant(
      of: find.byKey(ValueKey('module_logging_toggle_$module')),
      matching: find.byType(CupertinoSwitch),
    );
    final CupertinoSwitch widget = tester.widget(switchFinder);
    expect(widget.value, isFalse);
  });

  testWidgets('tapping a row toggle invokes onToggle with the module name and new value', (
    tester,
  ) async {
    String? toggledModule;
    bool? toggledValue;
    final module = kKnownLoggingModules.first;

    await pumpSection(
      tester,
      moduleToggles: const {},
      onToggle: (m, isEnabled) {
        toggledModule = m;
        toggledValue = isEnabled;
      },
    );

    final switchFinder = find.descendant(
      of: find.byKey(ValueKey('module_logging_toggle_$module')),
      matching: find.byType(CupertinoSwitch),
    );
    await tester.tap(switchFinder);
    await tester.pump();

    expect(toggledModule, module);
    // Was rendered enabled (absent = true), so tapping should toggle it off.
    expect(toggledValue, isFalse);
  });
}
