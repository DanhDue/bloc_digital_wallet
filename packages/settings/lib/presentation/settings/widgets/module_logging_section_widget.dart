// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:settings/generated/colors.gen.dart';
import 'package:settings/presentation/settings/models/logging_toggle_constants.dart';
import 'package:settings/presentation/settings/widgets/settings_item_widget.dart';
import 'package:settings/presentation/settings/widgets/settings_section_widget.dart';

/// Settings section listing one toggle row per known logging module (see
/// [kKnownLoggingModules]), so a developer/QA can mute a noisy module's
/// local logs at runtime.
///
/// This is a debug convenience only: it never affects whether a telemetry
/// backend receives records. That is a separate, production-impacting
/// control — see `TelemetrySectionWidget` — kept in its own visually
/// distinct section so a QA engineer can't accidentally disable Datadog
/// while trying to mute a noisy module here.
class ModuleLoggingSectionWidget extends StatelessWidget {
  const ModuleLoggingSectionWidget({
    required this.title,
    required this.moduleToggles,
    required this.onToggle,
    super.key,
  });

  /// Section header title.
  final String title;

  /// Explicit module -> enabled overrides. A module absent from this map
  /// renders as enabled (matches `LogManagerImpl`'s `?? true` default).
  final Map<String, bool> moduleToggles;

  /// Invoked with the module name and new toggle value when a row is
  /// switched.
  final void Function(String module, bool isEnabled) onToggle;

  @override
  Widget build(BuildContext context) {
    return SettingsSectionWidget(
      title: title,
      children: [
        for (var i = 0; i < kKnownLoggingModules.length; i++)
          SettingsItemWidget(
            key: ValueKey('module_logging_toggle_${kKnownLoggingModules[i]}'),
            icon: Icons.extension_outlined,
            label: kKnownLoggingModules[i],
            trailing: SettingsItemTrailing.toggle,
            isOn: moduleToggles[kKnownLoggingModules[i]] ?? true,
            showDivider: i != kKnownLoggingModules.length - 1,
            iconColor: AppColors.settingsItemGrey,
            onToggle: (value) => onToggle(kKnownLoggingModules[i], value),
          ),
      ],
    );
  }
}
