// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:logger/d3nexus_logger.dart';

/// Minimal fake [ILogManager] used to make the `D3NexusLogger` static
/// facade fake-able in [SettingsBloc] tests.
///
/// `D3NexusLogger` is a static facade wired via `D3NexusLogger.initialize`;
/// initializing it with this fake in test `setUp` lets tests assert the
/// bloc pushed the right module/appender toggle through the facade,
/// without depending on any concrete telemetry backend or on
/// `packages/logger`'s own `LogManagerImpl`.
class FakeLogManager implements ILogManager {
  final Map<String, bool> moduleToggleCalls = {};
  final Map<String, bool> appenderToggleCalls = {};

  @override
  ILogger getLogger(String module) => throw UnimplementedError();

  @override
  void registerAppender(ILogAppender appender) {}

  @override
  void log(LogRecord record) {}

  @override
  void setModuleEnabled(String module, bool enabled) {
    moduleToggleCalls[module] = enabled;
  }

  @override
  void setAppenderEnabled(String appenderId, bool enabled) {
    appenderToggleCalls[appenderId] = enabled;
  }
}
