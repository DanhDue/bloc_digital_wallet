// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:math';

import 'i_log_manager.dart';
import 'i_logger.dart';
import 'log_record.dart';

/// Generates short random hex ids for [LoggerImpl.traceId]/[LoggerImpl.spanId].
///
/// This is a correlation id, not a security token — a `dart:math` `Random`
/// source is sufficient (no cryptographic randomness requirement, and no
/// new pub dependency is needed to get it).
String generateCorrelationId({int byteLength = 8}) {
  final random = Random();
  final bytes = List<int>.generate(byteLength, (_) => random.nextInt(256));
  return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}

/// The concrete [ILogger] returned by [LogManagerImpl.getLogger].
///
/// Builds an immutable [LogRecord] for every `d`/`i`/`w`/`e`/`v` call and
/// hands it to the owning [ILogManager] via [ILogManager.log] for dispatch.
///
/// **Trace/span id strategy**: a [LoggerImpl] obtained fresh from
/// `getLogger(module)` is the root of a new trace — it generates a new
/// [traceId] and a root [spanId] (with no [parentSpanId]) at construction
/// time. [withSpan] derives a child [LoggerImpl] that keeps the same
/// [traceId] (the whole logical operation stays one trace) but gets a
/// freshly generated [spanId], with [parentSpanId] set to the parent's
/// [spanId] — this is what lets [LogRecord]s be reassembled into a call
/// tree later (see `buildTraceTree`). Nothing downstream depends on a
/// specific id-generation scheme; this one was chosen for simplicity.
///
/// **Caveat**: "fresh from `getLogger(module)`" only describes the
/// *first* call for a given module. `LogManagerImpl.getLogger` caches one
/// [LoggerImpl] per module (see [ILogManager.getLogger]'s "same logical
/// logger" contract), and [traceId]/[spanId] are `final` — fixed once at
/// construction. So every later `getLogger('wallet')` call returns the
/// same cached instance with the same trace/span for the rest of the
/// process, and every top-level (non-[withSpan]) `.d/.i/.w/.e/.v()` call
/// on it emits records with that same, unchanging [spanId]. Callers that
/// want a fresh trace per logical operation must call [withSpan] to get a
/// new span (see `buildTraceTree`'s handling of records that legitimately
/// share a `spanId`).
class LoggerImpl implements ILogger {
  /// Creates a logger for [module], owned by [manager].
  ///
  /// If [traceId]/[spanId] aren't supplied, a fresh root trace/span pair is
  /// generated — this is the path [LogManagerImpl.getLogger] uses to mint a
  /// brand-new per-module logger. [withSpan] instead supplies explicit
  /// [traceId]/[spanId]/[parentSpanId] values to derive a child span within
  /// the same trace.
  LoggerImpl(
    this.module, {
    required this.manager,
    String? traceId,
    String? spanId,
    this.parentSpanId,
  }) : traceId = traceId ?? generateCorrelationId(byteLength: 16),
       spanId = spanId ?? generateCorrelationId();

  /// Name of the module this logger emits records for.
  final String module;

  /// The manager this logger submits built [LogRecord]s to.
  final ILogManager manager;

  /// Identifier correlating this logger's records with the rest of its
  /// trace. Stable across [withSpan] calls.
  ///
  /// 16 bytes (32 lowercase hex characters), matching the W3C Trace
  /// Context `trace-id` length (https://www.w3.org/TR/trace-context/).
  @override
  final String traceId;

  /// Identifier of this logger's current span.
  ///
  /// 8 bytes (16 lowercase hex characters), matching the W3C Trace Context
  /// `parent-id` length (https://www.w3.org/TR/trace-context/).
  @override
  final String spanId;

  /// Identifier of the span this logger's span was created from, if any.
  final String? parentSpanId;

  void _log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    manager.log(
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
    return LoggerImpl(
      module,
      manager: manager,
      traceId: traceId,
      spanId: generateCorrelationId(),
      parentSpanId: spanId,
    );
  }
}
