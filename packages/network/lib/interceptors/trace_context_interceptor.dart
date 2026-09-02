// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dio/dio.dart';
import 'package:logger/d3nexus_logger.dart';

/// The [RequestOptions.extra] key a caller sets to an active [ILogger] to
/// have [TraceContextInterceptor] propagate its trace context across the
/// network boundary.
///
/// This is an explicit, per-request opt-in — mirroring this package's
/// existing `extra` conventions (see `AuthInterceptor`'s `is_retry` flag in
/// `auth_interceptor.dart`) — rather than any global/ambient "currently
/// active trace" mechanism. Callers that want a request correlated with a
/// trace set `options.extra[traceContextLoggerKey] = someLogger` before
/// dispatching it; requests that don't set it are left untouched.
const String traceContextLoggerKey = 'd3nexusLogger';

/// Injects a [W3C Trace Context](https://www.w3.org/TR/trace-context/)
/// `traceparent` header built from the active [ILogger] passed via
/// `options.extra[traceContextLoggerKey]`, so a backend instrumented with
/// an APM/Otel collector can continue the same trace client → server.
///
/// Depends only on `packages/logger`'s [ILogger] interface — never on any
/// concrete log appender (Talker/Datadog/Otel etc.). When no [ILogger] is
/// present in `extra`, this interceptor is a no-op: it does not synthesize
/// a fresh trace, it simply adds no header.
class TraceContextInterceptor extends Interceptor {
  /// The W3C `traceparent` header name.
  static const String headerName = 'traceparent';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final logger = options.extra[traceContextLoggerKey];
    if (logger is ILogger) {
      options.headers[headerName] = _buildTraceParent(logger);
    }
    handler.next(options);
  }

  /// Builds a `version-traceId-parentId-flags` header value per the W3C
  /// Trace Context spec: a literal `00` version, [ILogger.traceId] (32 hex
  /// chars), [ILogger.spanId] as the parent-id (16 hex chars), and a
  /// literal `01` "sampled" flag — this repo has no sampling-decision
  /// system, so every propagated trace is marked sampled.
  String _buildTraceParent(ILogger logger) {
    return '00-${logger.traceId}-${logger.spanId}-01';
  }
}
