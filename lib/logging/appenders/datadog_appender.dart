// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:logger/d3nexus_logger.dart';

/// Minimal shape of a Datadog log-sending client, as consumed by
/// [DatadogAppender].
///
/// This is a placeholder client interface pending real Datadog SDK
/// wiring. Task 4 research found the real `datadog_flutter_plugin`
/// package's `DatadogLogger` can't be constructed directly for DI/testing
/// purposes here: its constructor is annotated `@internal` and only
/// produces a usable instance via `DatadogLogging.createLogger`, which
/// itself requires a fully initialized `DatadogSdk` (native
/// platform-channel handshake, API keys, etc). Performing that native
/// initialization is out of scope for this task -- see the epic's
/// Non-Goals, which explicitly exclude real native telemetry SDK
/// integration in this iteration; the point of this interface is to make
/// the *shape* of that future adapter correct and independently
/// testable, not to wire a live backend. Once real SDK initialization
/// lands (see Epic HLD phased rollout), a concrete implementation of this
/// interface wrapping a real `DatadogLogger` can be injected into
/// [DatadogAppender] with no change to this appender or to
/// `packages/logger`.
abstract interface class DatadogLogClient {
  /// Sends a single log entry with [status] severity and optional
  /// [attributes] (correlation ids, error details, etc).
  void log(String message, {required String status, Map<String, Object?>? attributes});
}

/// A no-op [DatadogLogClient] used at app bootstrap until a real Datadog
/// SDK client is wired in. Keeps [DatadogAppender] constructible today
/// without a live backend.
class NoopDatadogLogClient implements DatadogLogClient {
  const NoopDatadogLogClient();

  @override
  void log(String message, {required String status, Map<String, Object?>? attributes}) {}
}

/// [ILogAppender] adapter that forwards [LogRecord]s to a [DatadogLogClient].
///
/// Production telemetry appender: never honors per-module mutes (see
/// [respectsModuleToggle]), so a module muted for local debugging can't
/// silently blind production observability.
class DatadogAppender implements ILogAppender {
  DatadogAppender(this._client);

  final DatadogLogClient _client;

  @override
  final String id = 'datadog';

  @override
  final bool respectsModuleToggle = false;

  @override
  void append(LogRecord record) {
    _client.log(
      record.message,
      status: _statusFor(record.level),
      attributes: <String, Object?>{
        'module': record.module,
        'traceId': record.traceId,
        'spanId': record.spanId,
        if (record.parentSpanId != null) 'parentSpanId': record.parentSpanId,
        if (record.error != null) 'error': record.error.toString(),
        if (record.stackTrace != null) 'stackTrace': record.stackTrace.toString(),
      },
    );
  }

  String _statusFor(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return 'trace';
      case LogLevel.debug:
        return 'debug';
      case LogLevel.info:
        return 'info';
      case LogLevel.warning:
        return 'warn';
      case LogLevel.error:
        return 'error';
    }
  }
}
