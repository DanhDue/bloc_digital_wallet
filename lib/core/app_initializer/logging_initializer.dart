// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:logger/d3nexus_logger.dart';
import 'package:settings/settings.dart' show SettingsLocalDataSource;
import 'package:talker_flutter/talker_flutter.dart' hide LogLevel;
import '../../di/injection.dart';
import '../../logging/appenders_for_environment.dart';
import 'package:core/core.dart';

class LoggingInitializer implements AppInitializer {
  @override
  Future<void> init() async {
    final talker = getIt<Talker>();

    // Initialize D3NexusLogger (backend-agnostic logging facade) with the
    // environment-appropriate appender set. See
    // `appendersForEnvironment` for the dev vs. staging/production split.
    final manager = LogManagerImpl();
    for (final appender in appendersForEnvironment(
      talker,
      isDevelopment: EnvironmentConfig.isDevelopment,
    )) {
      manager.registerAppender(appender);
    }

    // Apply any module/appender toggles the user set in a previous session
    // (Settings -> Module Logging / Telemetry) directly to `manager`,
    // before wiring it into the D3NexusLogger facade below. This must be
    // done on the LogManagerImpl instance directly (not via
    // D3NexusLogger.setModuleEnabled/setAppenderEnabled) since the facade
    // throws StateError until D3NexusLogger.initialize() has run — which
    // happens after this point.
    final settingsLocalDataSource = getIt<SettingsLocalDataSource>();
    final moduleToggles = await settingsLocalDataSource.getModuleToggles();
    for (final entry in moduleToggles.entries) {
      manager.setModuleEnabled(entry.key, entry.value);
    }
    final appenderToggles = await settingsLocalDataSource.getAppenderToggles();
    for (final entry in appenderToggles.entries) {
      manager.setAppenderEnabled(entry.key, entry.value);
    }

    D3NexusLogger.initialize(manager);
  }
}
