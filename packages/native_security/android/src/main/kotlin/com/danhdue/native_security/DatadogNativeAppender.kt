// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

package com.danhdue.native_security

import com.danhdue.logger_native_bridge.NativeLogAppender
import com.danhdue.logger_native_bridge.NativeLogEntry

/**
 * Native (Kotlin/Android) [NativeLogAppender] for Datadog, registered from
 * `native_security`'s own native code — per the `logger_native_bridge`
 * design spec, concrete backend appenders live in the CONSUMING module,
 * not inside `logger_native_bridge` itself (mirrors the Dart-side rule:
 * "core has zero concrete-SDK dependency, appenders live at the app
 * layer").
 *
 * **This is a placeholder, not a real Datadog SDK integration** — this
 * repo has no real `com.datadoghq:dd-sdk-android-logs` (or equivalent)
 * dependency/account set up anywhere, on either the Dart side or here.
 * Task 4 already established, for the Dart-side `DatadogAppender`, that
 * wiring a real Datadog/OTel SDK isn't achievable as a thin adapter
 * without out-of-scope native account/SDK provisioning — the exact same
 * reasoning applies here, symmetrically, on the native side. The shape of
 * this class (an `append(entry)` that would forward to a real
 * `Logger`/`Logs` client) is exactly where that real call would go once
 * the SDK/account exists; see the `// TODO(datadog-sdk)` marker below.
 *
 * What IS proven here (see
 * `android/src/test/kotlin/.../DatadogNativeAppenderHeadlessTest.kt`):
 * `D3NexusNativeLogger.d()` correctly reaches this appender's [append]
 * when the `"datadog"` toggle is enabled, and correctly skips it when
 * disabled — the same standard Task 4 already set for the Dart-side
 * `DatadogAppender`/`NoopDatadogLogClient` (architecture/dispatch-level
 * proof, no real network call).
 */
class DatadogNativeAppender : NativeLogAppender {
    override val id: String = "datadog"

    /**
     * Every entry this appender has been asked to append, in receipt
     * order. Exposed for tests; a real implementation would not need this
     * (the real Datadog SDK client would own delivery/buffering itself).
     */
    val delivered: MutableList<NativeLogEntry> = mutableListOf()

    override fun append(entry: NativeLogEntry) {
        // TODO(datadog-sdk): once a real Datadog Android SDK dependency
        // and account/client token are provisioned for this app, replace
        // this with e.g.:
        //   Logger.Builder(sdkCore).build().log(
        //       priority = entry.severity.toAndroidLogPriority(),
        //       message = entry.message,
        //       attributes = mapOf("tag" to entry.tag, "traceId" to entry.traceId),
        //   )
        // Until then, this appender exists purely to prove the headless
        // dispatch path (D3NexusNativeLogger -> toggle check -> appender)
        // works end-to-end with no FlutterEngine involved.
        delivered.add(entry)
    }
}
