// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

/// Severity level of a [LogRecord], ordered from least to most severe.
///
/// Mirrors the `d`/`i`/`w`/`e`/`v` shorthand used across this codebase's
/// logging call sites (see [ILogger] and the legacy
/// `packages/core/lib/utils/log.dart`) so existing call sites migrate with
/// no semantic changes.
enum LogLevel {
  /// Fine-grained diagnostic detail, typically off by default.
  verbose,

  /// Developer-facing diagnostic detail.
  debug,

  /// Notable application events under normal operation.
  info,

  /// Recoverable or unexpected conditions worth investigating.
  warning,

  /// Failures that likely require attention.
  error,
}

/// An immutable, backend-agnostic description of a single log event.
///
/// [LogRecord] is the unit of data an [ILogger] hands to an [ILogManager]
/// for dispatch to registered [ILogAppender]s. It carries enough structure
/// — [module], [level], and W3C Trace Context-style correlation ids
/// ([traceId], [spanId], [parentSpanId]) — for downstream dispatch,
/// module/appender toggling, and sequence reconstruction, without
/// referencing any concrete telemetry SDK.
///
/// See the [W3C Trace Context Specification](https://www.w3.org/TR/trace-context/)
/// for the correlation-id model these fields follow.
class LogRecord {
  /// Creates an immutable log record.
  const LogRecord({
    required this.module,
    required this.level,
    required this.message,
    required this.timestamp,
    required this.traceId,
    required this.spanId,
    this.parentSpanId,
    this.error,
    this.stackTrace,
  });

  /// Name of the module/feature that emitted this record (e.g. `'wallet'`).
  final String module;

  /// Severity of this record.
  final LogLevel level;

  /// Human-readable log message.
  final String message;

  /// When this record was created.
  final DateTime timestamp;

  /// Identifier correlating this record with the rest of its trace.
  ///
  /// Stable across an entire request/flow; see the W3C Trace Context spec.
  final String traceId;

  /// Identifier of the span this record belongs to.
  final String spanId;

  /// Identifier of the span that [spanId] was created from, if any.
  ///
  /// `null` for a root span.
  final String? parentSpanId;

  /// Optional error associated with this record.
  final Object? error;

  /// Optional stack trace associated with [error].
  final StackTrace? stackTrace;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LogRecord &&
        other.module == module &&
        other.level == level &&
        other.message == message &&
        other.timestamp == timestamp &&
        other.traceId == traceId &&
        other.spanId == spanId &&
        other.parentSpanId == parentSpanId &&
        other.error == error &&
        other.stackTrace == stackTrace;
  }

  @override
  int get hashCode => Object.hash(
    module,
    level,
    message,
    timestamp,
    traceId,
    spanId,
    parentSpanId,
    error,
    stackTrace,
  );

  @override
  String toString() =>
      'LogRecord(module: $module, level: $level, message: $message, '
      'traceId: $traceId, spanId: $spanId, parentSpanId: $parentSpanId)';
}
