// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:logger/d3nexus_logger.dart';
import 'package:talker_flutter/talker_flutter.dart' hide LogLevel;

/// [ILogAppender] adapter that forwards [LogRecord]s to a [Talker]
/// instance.
///
/// This is the local-debugging appender: it respects per-module toggles
/// (see [respectsModuleToggle]), so a module muted for local noise
/// reduction is silenced here too -- unlike the production telemetry
/// appenders ([ILogAppender]s such as `DatadogAppender`/`OtelAppender`)
/// which never honor module toggles.
class TalkerAppender implements ILogAppender {
  TalkerAppender(this._talker);

  final Talker _talker;

  @override
  final String id = 'talker';

  @override
  final bool respectsModuleToggle = true;

  @override
  void append(LogRecord record) {
    switch (record.level) {
      case LogLevel.verbose:
        _talker.verbose(record.message, record.error, record.stackTrace);
      case LogLevel.debug:
        _talker.debug(record.message, record.error, record.stackTrace);
      case LogLevel.info:
        _talker.info(record.message, record.error, record.stackTrace);
      case LogLevel.warning:
        _talker.warning(record.message, record.error, record.stackTrace);
      case LogLevel.error:
        _talker.error(record.message, record.error, record.stackTrace);
    }
  }
}
