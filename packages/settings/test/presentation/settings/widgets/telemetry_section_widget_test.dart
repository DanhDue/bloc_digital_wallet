// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:settings/presentation/settings/models/logging_toggle_constants.dart';
import 'package:settings/presentation/settings/widgets/telemetry_section_widget.dart';

void main() {
  const appenderLabels = {
    'talker': 'Talker (Debug Console)',
    'datadog': 'Datadog',
    'otel': 'OpenTelemetry',
  };

  Future<void> pumpSection(
    WidgetTester tester, {
    required Map<String, bool> appenderToggles,
    required void Function(String appenderId, bool isEnabled) onToggle,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TelemetrySectionWidget(
              title: 'Telemetry',
              appenderLabels: appenderLabels,
              appenderToggles: appenderToggles,
              onToggle: onToggle,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('renders one row per known appender id with its human-readable label', (
    tester,
  ) async {
    await pumpSection(tester, appenderToggles: const {}, onToggle: (_, _) {});

    for (final id in kKnownLogAppenderIds) {
      expect(find.text(appenderLabels[id]!), findsOneWidget);
    }
    expect(find.byType(CupertinoSwitch), findsNWidgets(kKnownLogAppenderIds.length));
  });

  testWidgets('an appender absent from the toggle map renders as enabled', (tester) async {
    await pumpSection(tester, appenderToggles: const {}, onToggle: (_, _) {});

    final switchFinder = find.descendant(
      of: find.byKey(const ValueKey('appender_logging_toggle_datadog')),
      matching: find.byType(CupertinoSwitch),
    );
    final CupertinoSwitch widget = tester.widget(switchFinder);
    expect(widget.value, isTrue);
  });

  testWidgets('an appender with an explicit false override renders as disabled', (tester) async {
    await pumpSection(tester, appenderToggles: const {'datadog': false}, onToggle: (_, _) {});

    final switchFinder = find.descendant(
      of: find.byKey(const ValueKey('appender_logging_toggle_datadog')),
      matching: find.byType(CupertinoSwitch),
    );
    final CupertinoSwitch widget = tester.widget(switchFinder);
    expect(widget.value, isFalse);
  });

  testWidgets(
    'tapping the Datadog row toggle invokes onToggle with appenderId=datadog and new value, '
    'without affecting other appenders',
    (tester) async {
      String? toggledId;
      bool? toggledValue;

      await pumpSection(
        tester,
        appenderToggles: const {},
        onToggle: (id, isEnabled) {
          toggledId = id;
          toggledValue = isEnabled;
        },
      );

      final switchFinder = find.descendant(
        of: find.byKey(const ValueKey('appender_logging_toggle_datadog')),
        matching: find.byType(CupertinoSwitch),
      );
      await tester.tap(switchFinder);
      await tester.pump();

      expect(toggledId, 'datadog');
      expect(toggledValue, isFalse);
    },
  );
}
