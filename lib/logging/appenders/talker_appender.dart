// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:logger/d3nexus_logger.dart';
import 'package:talker_flutter/talker_flutter.dart' hide LogLevel;
import 'package:talker_flutter/talker_flutter.dart' as talker_pkg show LogLevel;

/// [ILogAppender] adapter that forwards [LogRecord]s to a [Talker]
/// instance.
///
/// This is the local-debugging appender: it respects per-module toggles
/// (see [respectsModuleToggle]), so a module muted for local noise
/// reduction is silenced here too -- unlike the production telemetry
/// appenders ([ILogAppender]s such as `DatadogAppender`/`OtelAppender`)
/// which never honor module toggles.
///
/// Logs via [Talker.logCustom] rather than the level-named methods
/// (`.debug()`/`.info()`/etc.), tagging each entry's `title` with
/// [LogRecord.module]. Talker's own console screen derives its filter
/// chips from each entry's title, so this is what makes per-module
/// filtering ("Wallet", "Network", ...) show up there automatically.
class TalkerAppender implements ILogAppender {
  TalkerAppender(this._talker);

  final Talker _talker;

  @override
  final String id = 'talker';

  @override
  final bool respectsModuleToggle = true;

  @override
  void append(LogRecord record) {
    _talker.logCustom(
      TalkerLog(
        record.message,
        title: record.module,
        logLevel: _toTalkerLevel(record.level),
        exception: record.error,
        stackTrace: record.stackTrace,
      ),
    );
  }

  talker_pkg.LogLevel _toTalkerLevel(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return talker_pkg.LogLevel.verbose;
      case LogLevel.debug:
        return talker_pkg.LogLevel.debug;
      case LogLevel.info:
        return talker_pkg.LogLevel.info;
      case LogLevel.warning:
        return talker_pkg.LogLevel.warning;
      case LogLevel.error:
        return talker_pkg.LogLevel.error;
    }
  }
}
