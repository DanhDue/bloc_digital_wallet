// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:logger/d3nexus_logger.dart';

/// Minimal shape of an OpenTelemetry span-event client, as consumed by
/// [OtelAppender].
///
/// This is a placeholder client interface pending real OpenTelemetry SDK
/// wiring. Task 4 research found the `opentelemetry` pub package (pre-1.0,
/// v0.18.x at time of writing) models a span-centric API
/// (`Tracer.startSpan`/`Span.end`) whose own trace/span id generation and
/// `Context` propagation model don't map directly onto the
/// already-computed [LogRecord.traceId]/[LogRecord.spanId] without
/// integration work beyond this task's scope -- consistent with the
/// epic's Non-Goals, which explicitly exclude real native OpenTelemetry
/// integration in this iteration ("the native appender abstraction is
/// what makes adding OTel later a non-breaking addition"). This interface
/// captures the minimal "record a span event carrying these correlation
/// ids" shape a concrete adapter would call once that integration lands,
/// so it can be injected into [OtelAppender] with no change to this
/// appender or to `packages/logger`.
abstract interface class OtelSpanClient {
  /// Records a single span event named [name] with [severity] and the
  /// W3C Trace Context correlation ids from the originating [LogRecord].
  void recordSpanEvent({
    required String traceId,
    required String spanId,
    String? parentSpanId,
    required String name,
    required String severity,
    Map<String, String>? attributes,
  });
}

/// A no-op [OtelSpanClient] used at app bootstrap until a real
/// OpenTelemetry SDK client is wired in. Keeps [OtelAppender]
/// constructible today without a live backend.
class NoopOtelSpanClient implements OtelSpanClient {
  const NoopOtelSpanClient();

  @override
  void recordSpanEvent({
    required String traceId,
    required String spanId,
    String? parentSpanId,
    required String name,
    required String severity,
    Map<String, String>? attributes,
  }) {}
}

/// [ILogAppender] adapter that forwards [LogRecord]s to an
/// [OtelSpanClient].
///
/// Production telemetry appender: never honors per-module mutes (see
/// [respectsModuleToggle]), so a module muted for local debugging can't
/// silently blind production observability.
class OtelAppender implements ILogAppender {
  OtelAppender(this._client);

  final OtelSpanClient _client;

  @override
  final String id = 'otel';

  @override
  final bool respectsModuleToggle = false;

  @override
  void append(LogRecord record) {
    _client.recordSpanEvent(
      traceId: record.traceId,
      spanId: record.spanId,
      parentSpanId: record.parentSpanId,
      name: record.message,
      severity: record.level.name,
      attributes: <String, String>{
        'module': record.module,
        if (record.error != null) 'error': record.error.toString(),
      },
    );
  }
}
