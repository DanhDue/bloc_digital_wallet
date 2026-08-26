// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

package com.danhdue.logger_native_bridge

/**
 * A pluggable native log backend, mirroring `ILogAppender` on the Dart side
 * (`package:logger`).
 *
 * Concrete implementations (e.g. `DatadogNativeAppender`) live in the
 * *consuming* module's own native source (`packages/native_security`), not
 * in this package — this package's core has zero concrete-SDK dependency,
 * the same rule the epic already applies to `packages/logger`. Register an
 * appender via [D3NexusNativeLogger.registerAppender].
 *
 * This file has zero Flutter/Pigeon dependency.
 */
interface NativeLogAppender {
    /**
     * Stable identifier for this appender, matching the id used by the
     * Dart-side kill switch (`D3NexusLogger.setAppenderEnabled(id, ...)`)
     * and read back by [NativeAppenderToggleStore.isEnabled] — e.g.
     * `"datadog"`.
     */
    val id: String

    /** Delivers [entry] to this backend. Called only when [id] is enabled. */
    fun append(entry: NativeLogEntry)
}
