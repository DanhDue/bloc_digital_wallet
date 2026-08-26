// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'i_log_appender.dart';
import 'i_logger.dart';

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
}
