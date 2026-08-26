// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

/// A per-module logging entry point.
///
/// Method names mirror the legacy `Log` static API
/// (`packages/core/lib/utils/log.dart`) so existing call sites can migrate
/// to `ILogger` with no semantic changes.
abstract interface class ILogger {
  /// Identifier correlating this logger's records with the rest of its
  /// trace. Stable across [withSpan] calls.
  ///
  /// 16 bytes (32 lowercase hex characters), matching the W3C Trace
  /// Context `trace-id` length (https://www.w3.org/TR/trace-context/).
  /// Network-boundary callers (e.g. a Dio interceptor building a
  /// `traceparent` header) read this to propagate the active trace.
  String get traceId;

  /// Identifier of this logger's current span.
  ///
  /// 8 bytes (16 lowercase hex characters), matching the W3C Trace Context
  /// `parent-id` length (https://www.w3.org/TR/trace-context/).
  String get spanId;

  /// Logs a debug-level message.
  void d(String message, {Object? error, StackTrace? stackTrace});

  /// Logs an info-level message.
  void i(String message, {Object? error, StackTrace? stackTrace});

  /// Logs a warning-level message.
  void w(String message, {Object? error, StackTrace? stackTrace});

  /// Logs an error-level message.
  void e(String message, {Object? error, StackTrace? stackTrace});

  /// Logs a fine-grained verbose-level message.
  void v(String message, {Object? error, StackTrace? stackTrace});

  /// Returns a new [ILogger] scoped to a child span of this logger's
  /// current span.
  ///
  /// Implementations must stamp records emitted by the returned logger
  /// with a freshly generated span id, setting that record's parent span
  /// id to this logger's current span id, so downstream tooling can
  /// reconstruct call sequences (see the W3C Trace Context span model).
  ILogger withSpan();
}
