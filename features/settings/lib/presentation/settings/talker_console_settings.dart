// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:settings/presentation/settings/models/logging_toggle_constants.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Builds the "Module Logging" and "Telemetry" [CustomSettingsGroup]s shown
/// in the Talker console's settings panel (its ⚙️ icon), replacing what
/// used to be two standalone sections on the main Settings screen.
///
/// A module/appender absent from its toggle map defaults to enabled
/// (`true`), matching `LogManagerImpl`'s own `?? true` default. Toggling a
/// row calls the matching callback with the row's key (module name or
/// appender id) and the new value — callers are expected to both push the
/// change live (`D3NexusLogger.setModuleEnabled`/`setAppenderEnabled`) and
/// persist it (`SettingsLocalDataSource.saveModuleToggles`/
/// `saveAppenderToggles`).
List<CustomSettingsGroup> buildLoggingCustomSettings({
  required Map<String, bool> moduleToggles,
  required Map<String, bool> appenderToggles,
  required Map<String, String> appenderLabels,
  required String moduleLoggingTitle,
  required String telemetryTitle,
  required void Function(String module, bool isEnabled) onModuleToggle,
  required void Function(String appenderId, bool isEnabled) onAppenderToggle,
}) {
  return [
    CustomSettingsGroup(
      title: moduleLoggingTitle,
      items: [
        for (final module in kKnownLoggingModules)
          CustomSettingsItemBool(
            name: module,
            value: moduleToggles[module] ?? true,
            onChanged: (isEnabled) => onModuleToggle(module, isEnabled),
          ),
      ],
    ),
    CustomSettingsGroup(
      title: telemetryTitle,
      items: [
        for (final appenderId in kKnownLogAppenderIds)
          CustomSettingsItemBool(
            name: appenderLabels[appenderId] ?? appenderId,
            value: appenderToggles[appenderId] ?? true,
            onChanged: (isEnabled) => onAppenderToggle(appenderId, isEnabled),
          ),
      ],
    ),
  ];
}
