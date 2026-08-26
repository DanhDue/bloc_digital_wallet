// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

package com.danhdue.logger_native_bridge

import io.flutter.embedding.engine.plugins.FlutterPlugin

/**
 * The ONLY class in this package allowed to import Flutter/Pigeon.
 *
 * Everything else in `android/src/main/kotlin/.../logger_native_bridge`
 * ([D3NexusNativeLogger], [NativeLogAppender], [NativeLogQueue],
 * [NativeAppenderToggleStore], [NativeLogEntry], [NativeJson]) has zero
 * Flutter/Pigeon dependency and works with no engine at all — that is what
 * makes the headless push path (`D3NexusNativeLogger.d(...)` called from a
 * `WorkManager` `Worker` with no `FlutterEngine` running) possible.
 *
 * This plugin only matters once a `FlutterEngine` DOES attach: it
 * (re-)wires [D3NexusNativeLogger] to a real `SharedPreferences`-backed
 * [NativeAppenderToggleStore]/[NativeLogQueue] (in case nothing did so
 * earlier, e.g. no `Application.onCreate` bootstrap exists in this app
 * yet), then drains [NativeLogQueue] and replays each entry, in original
 * FIFO order, into Dart via the Pigeon-generated
 * `NativeLogFlutterApi.onNativeLog`. The queue is cleared ONLY after every
 * replayed entry's callback reports success — so a process death mid-replay
 * never LOSES entries: the whole batch (including any already-delivered
 * entries) simply replays again on the next attach, since [NativeLogQueue]
 * is only cleared after every entry in a batch succeeds (see
 * [NativeLogQueue.clear]'s doc comment). Note this means a partial-failure
 * replay CAN duplicate entries into Talker across attach attempts — that's
 * an accepted trade-off (see the design spec's "Replay is best-effort, not
 * guaranteed" rationale): correctness here means "never silently drop a
 * headless log," not "exactly-once delivery to a debug console."
 *
 * **`onAttachedToEngine`'s own drain call is best-effort only, NOT the
 * reliable replay path.** [onAttachedToEngine] runs during
 * `FlutterActivity.onCreate`/engine setup — strictly BEFORE the Dart side's
 * `main()` (and therefore before `NativeLogFlutterApi.setUp(...)` /
 * `registerNativeLogBridge()`) can possibly have run on a real cold start.
 * Calling [drainAndReplay] here can and normally DOES race an
 * as-yet-unregistered Dart handler: each `onNativeLog` send then lands in
 * Flutter's `ChannelBuffers` (capacity 1 per channel) and overflow entries
 * are silently dropped, Pigeon maps the resulting reply to a failure, and
 * this class correctly does NOT clear the queue in that case (see
 * [drainAndReplay]'s doc comment) — so this call fails safely, but it is
 * not what makes replay reliable. Implements the (also NOT merely a
 * dev/test convenience, despite the schema's own doc comment framing it
 * that way) [NativeLogHostApi] (`triggerFlush()`) precisely so the DART
 * side can explicitly re-request a drain once it has actually installed
 * its handler — see `NativeLogBridge.registerNativeLogBridge()`'s doc
 * comment (Dart) for the real, race-free replay path this app relies on.
 */
class NativeLogBridgePlugin : FlutterPlugin, NativeLogHostApi {
    private var queue: NativeLogQueue? = null
    private var flutterApi: NativeLogFlutterApi? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val context = binding.applicationContext
        val toggleStore = NativeAppenderToggleStore.from(context)
        val logQueue = NativeLogQueue.from(context)
        queue = logQueue

        // Idempotent: does not clear appenders already registered by an
        // earlier D3NexusNativeLogger.initialize() call (e.g. from a native
        // Application.onCreate bootstrap, if/when one exists).
        D3NexusNativeLogger.initialize(toggleStore, logQueue)

        val api = NativeLogFlutterApi(binding.binaryMessenger)
        flutterApi = api

        NativeLogHostApi.setUp(binding.binaryMessenger, this)

        drainAndReplay(logQueue, api)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        NativeLogHostApi.setUp(binding.binaryMessenger, null)
        flutterApi = null
        queue = null
    }

    /**
     * [NativeLogHostApi]: forces an immediate drain. Despite the Pigeon
     * schema's own doc comment calling this a "dev/test convenience," it is
     * ALSO the production replay path — `NativeLogBridge.
     * registerNativeLogBridge()` (Dart) calls this immediately after
     * installing its `onNativeLog` handler, since [onAttachedToEngine]'s own
     * attach-time drain call races (and normally loses to) Dart startup on
     * a real cold start. See this class's doc comment.
     */
    override fun triggerFlush() {
        val logQueue = queue ?: return
        val api = flutterApi ?: return
        drainAndReplay(logQueue, api)
    }

    /**
     * Drains every currently-queued entry and replays it, in original FIFO
     * order, via [api]. Clears [queue] only once every entry in THIS drain
     * batch has been acknowledged successfully — see [NativeLogQueue.clear].
     */
    private fun drainAndReplay(queue: NativeLogQueue, api: NativeLogFlutterApi) {
        val entries = queue.drainAll()
        if (entries.isEmpty()) return

        var pending = entries.size
        var sawFailure = false

        for (entry in entries) {
            api.onNativeLog(entry.toPigeonMessage()) { result ->
                pending -= 1
                if (result.isFailure) {
                    sawFailure = true
                }
                if (pending == 0 && !sawFailure) {
                    queue.clear()
                }
            }
        }
    }

    private fun NativeLogEntry.toPigeonMessage(): NativeLogMessage {
        return NativeLogMessage(
            level = severity.toPigeonLevel(),
            tag = tag,
            message = message,
            timestamp = timestampMillis,
            traceId = traceId,
        )
    }

    private fun NativeLogSeverity.toPigeonLevel(): NativeLogLevel =
        when (this) {
            NativeLogSeverity.VERBOSE -> NativeLogLevel.VERBOSE
            NativeLogSeverity.DEBUG -> NativeLogLevel.DEBUG
            NativeLogSeverity.INFO -> NativeLogLevel.INFO
            NativeLogSeverity.WARNING -> NativeLogLevel.WARNING
            NativeLogSeverity.ERROR -> NativeLogLevel.ERROR
        }
}
