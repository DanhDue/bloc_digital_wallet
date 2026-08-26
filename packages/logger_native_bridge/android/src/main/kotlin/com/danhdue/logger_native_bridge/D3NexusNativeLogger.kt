// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

package com.danhdue.logger_native_bridge

/**
 * Native-side facade a headless `WorkManager` `Worker` / `BroadcastReceiver`
 * / foreground `Service` calls directly, e.g. `D3NexusNativeLogger.d(tag,
 * message)` — with NO `FlutterEngine` or Pigeon channel involved at all.
 * Mirrors `D3NexusLogger` on the Dart side.
 *
 * **Dispatch order** (see the design spec's headless sequence diagram): for
 * each `d`/`i`/`w`/`e`/`v` call, every registered [NativeLogAppender] is
 * checked against [NativeAppenderToggleStore.isEnabled] — disabled
 * appenders are skipped, enabled ones receive the entry. Regardless of any
 * toggle, the entry is ALWAYS enqueued into [NativeLogQueue] afterwards:
 * toggles gate live backend delivery, not local replay visibility, so a
 * developer can still see a headless log on Talker even if its backend was
 * disabled at the time.
 *
 * Call [initialize] once (e.g. from `Application.onCreate`, a `Worker`'s
 * first use, or [NativeLogBridgePlugin.onAttachedToEngine] as a fallback if
 * nothing else got there first) before [registerAppender] / `d`/`i`/`w`/
 * `e`/`v`. [initialize] is safe to call more than once — it does NOT clear
 * previously registered appenders, so an engine attach after
 * `Application.onCreate` already registered a `DatadogNativeAppender`
 * doesn't silently lose it.
 *
 * **Thread safety**: this is the exact class real headless callers hit from
 * background `WorkManager`/`Service` threads, potentially concurrently with
 * a main-thread `registerAppender` call (e.g. app startup racing a
 * just-scheduled `Worker`). [initialize]/[registerAppender]/[resetForTest]
 * are `@Synchronized` (Kotlin synchronizes on this singleton `object`
 * instance itself). [log] takes a consistent snapshot of [toggleStore] and
 * a defensive copy of [appenders] under that same lock, THEN releases the
 * lock before dispatching to each appender/[queue] — this fixes the actual
 * data race ([registerAppender] mutating [appenders] while [log] iterates
 * it, which risked a `ConcurrentModificationException`) without holding the
 * lock across foreign [NativeLogAppender.append] calls (which could be
 * slow, e.g. a real SDK's I/O) or risking a same-thread re-entrant
 * deadlock if an appender ever logged back through this facade.
 *
 * This file has zero Flutter/Pigeon dependency.
 */
object D3NexusNativeLogger {
    private var toggleStore: NativeAppenderToggleStore? = null
    private var queue: NativeLogQueue? = null
    private val appenders = mutableListOf<NativeLogAppender>()

    /**
     * Wires this facade to [toggleStore] and [queue]. Must be called before
     * `d`/`i`/`w`/`e`/`v`. Safe to call more than once (e.g. once from
     * `Application.onCreate` and again from [NativeLogBridgePlugin]) —
     * later calls replace [toggleStore]/[queue] but never clear already
     * [registerAppender]-ed appenders.
     */
    @Synchronized
    fun initialize(toggleStore: NativeAppenderToggleStore, queue: NativeLogQueue) {
        this.toggleStore = toggleStore
        this.queue = queue
    }

    /** Registers [appender] to receive future dispatch, subject to its toggle. */
    @Synchronized
    fun registerAppender(appender: NativeLogAppender) {
        appenders.add(appender)
    }

    /**
     * Test-only: clears every registered appender and un-initializes the
     * toggle store/queue, so each test starts from a clean slate despite
     * this facade being a singleton `object`. Production code must never
     * call this.
     */
    @Synchronized
    fun resetForTest() {
        appenders.clear()
        toggleStore = null
        queue = null
    }

    fun d(tag: String, message: String, traceId: String? = null) =
        log(NativeLogSeverity.DEBUG, tag, message, traceId)

    fun i(tag: String, message: String, traceId: String? = null) =
        log(NativeLogSeverity.INFO, tag, message, traceId)

    fun w(tag: String, message: String, traceId: String? = null) =
        log(NativeLogSeverity.WARNING, tag, message, traceId)

    fun e(tag: String, message: String, traceId: String? = null) =
        log(NativeLogSeverity.ERROR, tag, message, traceId)

    fun v(tag: String, message: String, traceId: String? = null) =
        log(NativeLogSeverity.VERBOSE, tag, message, traceId)

    private fun log(severity: NativeLogSeverity, tag: String, message: String, traceId: String?) {
        // Snapshot the shared mutable state under the lock, then release it
        // before dispatching -- see this class's "Thread safety" doc
        // comment for why.
        val (store, snapshotAppenders, activeQueue) =
            synchronized(this) {
                val store =
                    toggleStore
                        ?: error(
                            "D3NexusNativeLogger.initialize() must be called before " +
                                "logging. Call it once during native bootstrap.",
                        )
                Triple(store, appenders.toList(), queue)
            }

        val entry = NativeLogEntry(severity, tag, message, System.currentTimeMillis(), traceId)

        for (appender in snapshotAppenders) {
            if (store.isEnabled(appender.id)) {
                appender.append(entry)
            }
        }

        activeQueue?.enqueue(entry)
    }
}
