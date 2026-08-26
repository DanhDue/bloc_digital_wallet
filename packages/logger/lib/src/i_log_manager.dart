// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'i_log_appender.dart';
import 'i_logger.dart';
import 'log_record.dart';

/// Coordinates [ILogger] instances and dispatch to registered
/// [ILogAppender]s.
///
/// This is the single seam through which `D3NexusLogger` reaches concrete
/// logging backends; `packages/logger` itself ships no implementation of
/// this interface.
abstract interface class ILogManager {
  /// Returns the [ILogger] for [module].
  ///
  /// Implementations should return the same logical logger for repeated
  /// calls with the same [module] name, so callers can safely call this
  /// once per module and reuse the result.
  ILogger getLogger(String module);

  /// Registers [appender] to receive log records dispatched by loggers
  /// obtained from [getLogger].
  void registerAppender(ILogAppender appender);

  /// Submits [record] for dispatch to every registered [ILogAppender],
  /// honoring both the per-appender kill switch ([setAppenderEnabled]) and
  /// the per-module mute ([setModuleEnabled]).
  ///
  /// This is the entry point a concrete [ILogger] calls once it has built
  /// a [LogRecord]; callers outside an [ILogger] implementation shouldn't
  /// normally need to call this directly.
  void log(LogRecord record);

  /// Enables or disables dispatch for [module].
  ///
  /// A disabled module is only skipped for appenders whose
  /// [ILogAppender.respectsModuleToggle] is `true`; it never blocks
  /// appenders that opt out of module toggling. Modules are enabled by
  /// default until this is called.
  void setModuleEnabled(String module, bool enabled);

  /// Enables or disables dispatch to the appender identified by
  /// [appenderId].
  ///
  /// This is a hard kill switch: when disabled, that appender receives no
  /// records regardless of module toggles. Appenders are enabled by
  /// default until this is called.
  void setAppenderEnabled(String appenderId, bool enabled);
}
