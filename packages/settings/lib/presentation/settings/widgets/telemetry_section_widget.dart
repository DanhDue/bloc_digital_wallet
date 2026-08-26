// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:settings/generated/colors.gen.dart';
import 'package:settings/presentation/settings/models/logging_toggle_constants.dart';
import 'package:settings/presentation/settings/widgets/settings_item_widget.dart';
import 'package:settings/presentation/settings/widgets/settings_section_widget.dart';

/// Settings section listing one toggle row per known telemetry appender id
/// (see [kKnownLogAppenderIds]) — a hard kill switch for a telemetry
/// backend (e.g. Datadog, OpenTelemetry) at runtime.
///
/// This is production-impacting and kept in its own visually distinct
/// section, separate from `ModuleLoggingSectionWidget`'s debug-only module
/// mutes, so a QA engineer can't accidentally disable Datadog while trying
/// to mute a noisy module's local logs.
class TelemetrySectionWidget extends StatelessWidget {
  const TelemetrySectionWidget({
    required this.title,
    required this.appenderLabels,
    required this.appenderToggles,
    required this.onToggle,
    super.key,
  });

  /// Section header title.
  final String title;

  /// Human-readable label per appender id (e.g. `'talker'` ->
  /// `'Talker (Debug Console)'`). Falls back to the raw id if a label is
  /// missing.
  final Map<String, String> appenderLabels;

  /// Explicit appender id -> enabled overrides. An appender absent from
  /// this map renders as enabled (matches `LogManagerImpl`'s `?? true`
  /// default).
  final Map<String, bool> appenderToggles;

  /// Invoked with the appender id and new toggle value when a row is
  /// switched.
  final void Function(String appenderId, bool isEnabled) onToggle;

  @override
  Widget build(BuildContext context) {
    return SettingsSectionWidget(
      title: title,
      children: [
        for (var i = 0; i < kKnownLogAppenderIds.length; i++)
          SettingsItemWidget(
            key: ValueKey('appender_logging_toggle_${kKnownLogAppenderIds[i]}'),
            icon: Icons.cloud_outlined,
            label: appenderLabels[kKnownLogAppenderIds[i]] ?? kKnownLogAppenderIds[i],
            trailing: SettingsItemTrailing.toggle,
            isOn: appenderToggles[kKnownLogAppenderIds[i]] ?? true,
            showDivider: i != kKnownLogAppenderIds.length - 1,
            iconColor: AppColors.settingsItemOrange,
            onToggle: (value) => onToggle(kKnownLogAppenderIds[i], value),
          ),
      ],
    );
  }
}
