// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

package com.danhdue.logger_native_bridge

/**
 * Severity of a [NativeLogEntry]. Mirrors `LogLevel` in `package:logger`
 * (Dart) and the Pigeon-generated `NativeLogLevel`, but is intentionally a
 * separate type: this file has zero Flutter/Pigeon dependency, so the
 * native core (this file, [NativeLogQueue], [NativeAppenderToggleStore],
 * [D3NexusNativeLogger], [NativeLogAppender]) compiles and runs with no
 * Flutter engine, no Pigeon-generated code, and no Android instrumentation
 * on the classpath at all. Only [NativeLogBridgePlugin] knows how to map
 * this enum to the Pigeon-generated `NativeLogLevel`.
 */
enum class NativeLogSeverity {
    VERBOSE,
    DEBUG,
    INFO,
    WARNING,
    ERROR,
}

/**
 * A single native log event, as seen by [D3NexusNativeLogger] and dispatched
 * to registered [NativeLogAppender]s / enqueued into [NativeLogQueue].
 *
 * [timestampMillis] is epoch milliseconds (UTC), captured at the moment the
 * originating `D3NexusNativeLogger.d/i/w/e/v(...)` call happened (NOT at
 * enqueue/drain/replay time) so that best-effort replay into Talker later
 * preserves original causal ordering and timing.
 */
data class NativeLogEntry(
    val severity: NativeLogSeverity,
    val tag: String,
    val message: String,
    val timestampMillis: Long,
    val traceId: String? = null,
)
