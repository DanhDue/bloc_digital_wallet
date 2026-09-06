// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter_test/flutter_test.dart';
import 'package:settings/presentation/settings/models/logging_toggle_constants.dart';
import 'package:settings/presentation/settings/talker_console_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() {
  group('buildLoggingCustomSettings', () {
    late List<MapEntry<String, bool>> moduleCalls;
    late List<MapEntry<String, bool>> appenderCalls;

    List<CustomSettingsGroup> build({
      Map<String, bool> moduleToggles = const {},
      Map<String, bool> appenderToggles = const {},
    }) {
      return buildLoggingCustomSettings(
        moduleToggles: moduleToggles,
        appenderToggles: appenderToggles,
        appenderLabels: const {
          'talker': 'Talker (Debug Console)',
          'datadog': 'Datadog',
          'otel': 'OpenTelemetry',
        },
        moduleLoggingTitle: 'Module Logging',
        telemetryTitle: 'Telemetry',
        onModuleToggle: (module, isEnabled) => moduleCalls.add(MapEntry(module, isEnabled)),
        onAppenderToggle: (id, isEnabled) => appenderCalls.add(MapEntry(id, isEnabled)),
      );
    }

    setUp(() {
      moduleCalls = [];
      appenderCalls = [];
    });

    test('returns exactly two groups titled Module Logging and Telemetry', () {
      final groups = build();
      expect(groups, hasLength(2));
      expect(groups[0].title, 'Module Logging');
      expect(groups[1].title, 'Telemetry');
    });

    test('module group has one row per kKnownLoggingModules, in order', () {
      final groups = build();
      final moduleGroup = groups[0];
      expect(moduleGroup.items.map((i) => i.name), kKnownLoggingModules);
    });

    test('telemetry group has one row per kKnownLogAppenderIds, labelled', () {
      final groups = build();
      final telemetryGroup = groups[1];
      expect(telemetryGroup.items.map((i) => i.name), [
        'Talker (Debug Console)',
        'Datadog',
        'OpenTelemetry',
      ]);
    });

    test('a module absent from the toggle map defaults to enabled (true)', () {
      final groups = build(moduleToggles: const {});
      final row = groups[0].items.first;
      expect(row.value, isTrue);
    });

    test('a module with an explicit false override renders as disabled', () {
      final groups = build(moduleToggles: {kKnownLoggingModules.first: false});
      final row = groups[0].items.first;
      expect(row.value, isFalse);
    });

    test('an appender absent from the toggle map defaults to enabled (true)', () {
      final groups = build(appenderToggles: const {});
      final row = groups[1].items.first;
      expect(row.value, isTrue);
    });

    test('an appender with an explicit false override renders as disabled', () {
      final groups = build(appenderToggles: {kKnownLogAppenderIds.first: false});
      final row = groups[1].items.first;
      expect(row.value, isFalse);
    });

    test('toggling a module row calls onModuleToggle with the module name and new value', () {
      final groups = build();
      final row = groups[0].items[1]; // second known module
      row.onChanged(false);
      expect(moduleCalls, hasLength(1));
      expect(moduleCalls.single.key, kKnownLoggingModules[1]);
      expect(moduleCalls.single.value, isFalse);
      expect(appenderCalls, isEmpty);
    });

    test('toggling an appender row calls onAppenderToggle with the id and new value', () {
      final groups = build();
      final row = groups[1].items[1]; // second known appender
      row.onChanged(false);
      expect(appenderCalls, hasLength(1));
      expect(appenderCalls.single.key, kKnownLogAppenderIds[1]);
      expect(appenderCalls.single.value, isFalse);
      expect(moduleCalls, isEmpty);
    });
  });
}
