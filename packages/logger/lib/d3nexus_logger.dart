// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

/// D3Nexus logging package.
///
/// Backend-agnostic logging interfaces (`LogRecord`, `ILogger`,
/// `ILogAppender`, `ILogManager`) plus the [D3NexusLogger] static facade,
/// for the DanhDue ExOICTIF digital wallet workspace. This package
/// contains no concrete telemetry SDK dependency; concrete implementations
/// live elsewhere and are wired in via [D3NexusLogger.initialize].
library;

import 'src/i_log_manager.dart';
import 'src/i_logger.dart';

export 'src/i_log_appender.dart';
export 'src/i_log_manager.dart';
export 'src/i_logger.dart';
export 'src/log_record.dart';

/// Static facade over the D3Nexus logging system.
///
/// Mirrors the ergonomics of the legacy `Log` static API (see
/// `packages/core/lib/utils/log.dart`) while delegating all real work to
/// an injected [ILogManager], keeping this package free of any concrete
/// telemetry SDK dependency.
///
/// Call [initialize] once during app startup with a concrete
/// [ILogManager], then use [getLogger] to obtain a per-module [ILogger].
abstract final class D3NexusLogger {
  static ILogManager? _manager;

  /// Wires this facade to [manager]. Must be called before [getLogger].
  static void initialize(ILogManager manager) {
    _manager = manager;
  }

  /// Returns the [ILogger] for [module], delegating to the [ILogManager]
  /// supplied via [initialize].
  ///
  /// Throws a [StateError] if called before [initialize].
  static ILogger getLogger(String module) {
    final manager = _manager;
    if (manager == null) {
      throw StateError(
        'D3NexusLogger.initialize() must be called before '
        'D3NexusLogger.getLogger(). Call D3NexusLogger.initialize() once '
        'during app startup.',
      );
    }
    return manager.getLogger(module);
  }
}
