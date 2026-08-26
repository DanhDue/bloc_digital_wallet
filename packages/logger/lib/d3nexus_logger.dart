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
export 'src/log_manager_impl.dart';
export 'src/log_record.dart';
export 'src/logger_impl.dart';
export 'src/trace_tree.dart';

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
    return _requireManager().getLogger(module);
  }

  /// Enables or disables dispatch for [module], delegating to the
  /// [ILogManager] supplied via [initialize].
  ///
  /// Throws a [StateError] if called before [initialize].
  static void setModuleEnabled(String module, bool enabled) {
    _requireManager().setModuleEnabled(module, enabled);
  }

  /// The current, live value of [module]'s toggle, delegating to the
  /// [ILogManager] supplied via [initialize].
  ///
  /// For callers that want to gate their own behavior on a module's toggle
  /// in real time (e.g. an interceptor deciding per-call whether to log),
  /// rather than reading it once at startup.
  ///
  /// Throws a [StateError] if called before [initialize].
  static bool isModuleEnabled(String module) {
    return _requireManager().isModuleEnabled(module);
  }

  /// Enables or disables dispatch to the appender identified by
  /// [appenderId], delegating to the [ILogManager] supplied via
  /// [initialize].
  ///
  /// Throws a [StateError] if called before [initialize].
  static void setAppenderEnabled(String appenderId, bool enabled) {
    _requireManager().setAppenderEnabled(appenderId, enabled);
  }

  static ILogManager _requireManager() {
    final manager = _manager;
    if (manager == null) {
      throw StateError(
        'D3NexusLogger.initialize() must be called before using '
        'D3NexusLogger. Call D3NexusLogger.initialize() once during app '
        'startup.',
      );
    }
    return manager;
  }
}
