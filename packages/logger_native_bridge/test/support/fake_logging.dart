// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

// Minimal, hand-rolled test doubles for package:logger's interfaces --
// mirrors packages/logger/test/support/fake_logging.dart (that file lives
// under packages/logger/test/, not lib/, so it isn't importable from this
// package; this is a deliberate small duplication, not a design
// divergence).

import 'package:logger/d3nexus_logger.dart';

/// A minimal [ILogger] fake that records every emitted [LogRecord].
class FakeLogger implements ILogger {
  FakeLogger(
    this.module, {
    required this.traceId,
    required this.spanId,
    this.parentSpanId,
    List<LogRecord>? records,
  }) : records = records ?? <LogRecord>[];

  final String module;

  @override
  final String traceId;

  @override
  final String spanId;

  final String? parentSpanId;

  /// Every record emitted by this logger or any span derived from it.
  final List<LogRecord> records;

  int _spanSequence = 0;

  void _log(LogLevel level, String message, {Object? error, StackTrace? stackTrace}) {
    records.add(
      LogRecord(
        module: module,
        level: level,
        message: message,
        timestamp: DateTime.now(),
        traceId: traceId,
        spanId: spanId,
        parentSpanId: parentSpanId,
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }

  @override
  void d(String message, {Object? error, StackTrace? stackTrace}) =>
      _log(LogLevel.debug, message, error: error, stackTrace: stackTrace);

  @override
  void i(String message, {Object? error, StackTrace? stackTrace}) =>
      _log(LogLevel.info, message, error: error, stackTrace: stackTrace);

  @override
  void w(String message, {Object? error, StackTrace? stackTrace}) =>
      _log(LogLevel.warning, message, error: error, stackTrace: stackTrace);

  @override
  void e(String message, {Object? error, StackTrace? stackTrace}) =>
      _log(LogLevel.error, message, error: error, stackTrace: stackTrace);

  @override
  void v(String message, {Object? error, StackTrace? stackTrace}) =>
      _log(LogLevel.verbose, message, error: error, stackTrace: stackTrace);

  @override
  ILogger withSpan() {
    _spanSequence += 1;
    return FakeLogger(
      module,
      traceId: traceId,
      spanId: '$spanId.$_spanSequence',
      parentSpanId: spanId,
      records: records,
    );
  }
}

/// A minimal [ILogManager] fake that caches one [FakeLogger] per module.
class FakeLogManager implements ILogManager {
  final Map<String, ILogger> _loggers = <String, ILogger>{};

  final List<ILogAppender> appenders = <ILogAppender>[];
  final List<LogRecord> logged = <LogRecord>[];
  final Map<String, bool> moduleToggles = <String, bool>{};
  final Map<String, bool> appenderToggles = <String, bool>{};

  @override
  ILogger getLogger(String module) {
    return _loggers.putIfAbsent(
      module,
      () => FakeLogger(module, traceId: 'trace-$module', spanId: 'span-0'),
    );
  }

  @override
  void registerAppender(ILogAppender appender) {
    appenders.add(appender);
  }

  @override
  void log(LogRecord record) {
    logged.add(record);
  }

  @override
  void setModuleEnabled(String module, bool enabled) {
    moduleToggles[module] = enabled;
  }

  @override
  bool isModuleEnabled(String module) => moduleToggles[module] ?? true;

  @override
  void setAppenderEnabled(String appenderId, bool enabled) {
    appenderToggles[appenderId] = enabled;
  }
}
