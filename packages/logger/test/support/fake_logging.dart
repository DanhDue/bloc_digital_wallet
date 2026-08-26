// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

// Minimal, hand-rolled test doubles for the interfaces defined by
// `packages/logger`.
//
// Task 2 defines interfaces only — no concrete ILogger/ILogManager
// implementation ships from this package (that's Task 3). These fakes
// exist purely to exercise the interface contracts in tests: they prove
// the shapes are usable and can support the documented `withSpan`
// span-stamping semantics and per-module logger distinctness.

import 'package:logger/d3nexus_logger.dart';

/// A minimal [ILogger] fake that records every emitted [LogRecord] and
/// implements [withSpan] per the documented contract: a fresh `spanId`
/// with `parentSpanId` set to the current span.
class FakeLogger implements ILogger {
  FakeLogger(
    this.module, {
    required this.traceId,
    required this.spanId,
    this.parentSpanId,
    List<LogRecord>? records,
  }) : records = records ?? <LogRecord>[];

  final String module;
  final String traceId;
  final String spanId;
  final String? parentSpanId;

  /// Every record emitted by this logger or any span derived from it.
  final List<LogRecord> records;

  int _spanSequence = 0;

  void _log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
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

/// A minimal [ILogManager] fake that caches one [FakeLogger] per module
/// and records registered appenders.
class FakeLogManager implements ILogManager {
  final Map<String, ILogger> _loggers = <String, ILogger>{};

  /// Appenders registered via [registerAppender], in registration order.
  final List<ILogAppender> appenders = <ILogAppender>[];

  /// Records passed to [log].
  final List<LogRecord> logged = <LogRecord>[];

  /// Module toggles set via [setModuleEnabled].
  final Map<String, bool> moduleToggles = <String, bool>{};

  /// Appender toggles set via [setAppenderEnabled].
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
  void setAppenderEnabled(String appenderId, bool enabled) {
    appenderToggles[appenderId] = enabled;
  }
}

/// A minimal [ILogAppender] fake that records every appended [LogRecord].
class FakeAppender implements ILogAppender {
  FakeAppender(this.id, {this.respectsModuleToggle = true});

  @override
  final String id;

  @override
  final bool respectsModuleToggle;

  /// Every record passed to [append].
  final List<LogRecord> received = <LogRecord>[];

  @override
  void append(LogRecord record) => received.add(record);
}
