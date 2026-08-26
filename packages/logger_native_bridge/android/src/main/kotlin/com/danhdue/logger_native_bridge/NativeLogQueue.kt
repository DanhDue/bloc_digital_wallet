// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

package com.danhdue.logger_native_bridge

import android.content.Context
import android.content.SharedPreferences

/**
 * A bounded, FIFO, drop-oldest ring buffer of [NativeLogEntry] values,
 * persisted to the native `SharedPreferences` file so it survives process
 * death between the headless push and the next Flutter engine attach.
 *
 * Backed by the SAME native preferences suite [NativeAppenderToggleStore]
 * reads from (`"FlutterSharedPreferences"`), but under its OWN key
 * ([RAW_KEY]) — this is a queue of best-effort replay entries, not a
 * toggle map, so it must not collide with `logging.appender_toggles`.
 * Unlike the toggle key, [RAW_KEY] is written and read exclusively by
 * native code (Dart never touches it directly), so it deliberately does
 * NOT carry the `flutter.` prefix `shared_preferences` adds to
 * Dart-written keys — that prefix is a `shared_preferences`-plugin
 * convention, not a requirement of the shared preferences file itself.
 *
 * Bound: [maxEntries] entries (default 200) OR [maxBytes] of encoded JSON
 * (default 64KB), whichever is hit first — the OLDEST entry is dropped to
 * make room, per the design spec's "Replay is best-effort, not
 * guaranteed" rationale (durable delivery already happened via the native
 * SDK during the original headless push; this queue only exists for
 * developer-facing Talker visibility).
 *
 * **Per-call cost**: [enqueue] necessarily does a read-modify-write of the
 * ENTIRE queue on every call — there's no partial-append operation on a
 * `SharedPreferences` string value, and swapping the backing store for
 * something that supports one (e.g. a small file with true appends) is an
 * already-acknowledged, deliberately-deferred option (see the design
 * spec's "Risks & Rollback" section) if this bound is ever hit hard enough
 * to matter. What this class DOES avoid is redundant JSON *decoding*:
 * [readAll] caches the last-decoded entry list, invalidated only when the
 * raw string actually differs from what's cached, and [writeAll] updates
 * that cache directly from the entries it just wrote (no read-back
 * needed) — so a burst of [enqueue] calls only ever re-decodes once
 * (lazily, on first access after a cold start), not once per call. This is
 * judged acceptable given the intended usage (infrequent headless
 * background events -- one `WorkManager` push at a time -- not a hot
 * logging loop).
 *
 * This file has zero Flutter/Pigeon dependency.
 */
class NativeLogQueue(
    private val sharedPreferences: SharedPreferences,
    private val maxEntries: Int = DEFAULT_MAX_ENTRIES,
    private val maxBytes: Int = DEFAULT_MAX_BYTES,
) {
    private var cachedRawJson: String? = null
    private var cachedEntries: List<NativeLogEntry> = emptyList()

    /**
     * Appends [entry] to the tail of the queue, dropping the oldest
     * entry/entries first if appending would exceed [maxEntries] or
     * [maxBytes].
     */
    @Synchronized
    fun enqueue(entry: NativeLogEntry) {
        val entries = readAll().toMutableList()
        entries.add(entry)
        while (entries.size > maxEntries || encodedByteSize(entries) > maxBytes) {
            if (entries.isEmpty()) break
            entries.removeAt(0)
        }
        writeAll(entries)
    }

    /** Returns every currently-queued entry, oldest first. Does not clear. */
    @Synchronized
    fun drainAll(): List<NativeLogEntry> = readAll()

    /**
     * Clears the queue. Callers (namely [NativeLogBridgePlugin]) must only
     * call this AFTER every drained entry has been successfully replayed —
     * clearing first and replaying second would lose entries if the
     * process dies mid-replay.
     */
    @Synchronized
    fun clear() {
        sharedPreferences.edit().remove(RAW_KEY).apply()
        cachedRawJson = null
        cachedEntries = emptyList()
    }

    /** Number of entries currently queued. Exposed for tests/diagnostics. */
    @Synchronized
    fun size(): Int = readAll().size

    private fun readAll(): List<NativeLogEntry> {
        val json = sharedPreferences.getString(RAW_KEY, null)
        if (json == cachedRawJson) {
            // Nothing has changed under RAW_KEY since the last read/write:
            // skip re-decoding entirely.
            return cachedEntries
        }
        val decoded = decodeEntries(json)
        cachedRawJson = json
        cachedEntries = decoded
        return decoded
    }

    private fun decodeEntries(json: String?): List<NativeLogEntry> {
        if (json == null) return emptyList()
        return try {
            val decoded = NativeJson.decode(json)
            if (decoded !is List<*>) return emptyList()
            decoded.mapNotNull { decodeEntry(it) }
        } catch (e: NativeJsonException) {
            emptyList()
        } catch (e: RuntimeException) {
            // Defense in depth: NativeJson.decode is contracted to only
            // ever throw NativeJsonException for malformed input, but this
            // is the exact path a headless background task depends on
            // never crashing -- fail open on any other unexpected runtime
            // exception too, rather than trust that contract absolutely.
            emptyList()
        }
    }

    private fun writeAll(entries: List<NativeLogEntry>) {
        val json = encode(entries)
        sharedPreferences.edit().putString(RAW_KEY, json).apply()
        // Update the cache directly from what we just wrote instead of
        // reading it back and re-decoding.
        cachedRawJson = json
        cachedEntries = entries
    }

    private fun encodedByteSize(entries: List<NativeLogEntry>): Int {
        return encode(entries).toByteArray(Charsets.UTF_8).size
    }

    private fun encode(entries: List<NativeLogEntry>): String {
        val list = entries.map { entry ->
            linkedMapOf<String, Any?>(
                "severity" to entry.severity.name,
                "tag" to entry.tag,
                "message" to entry.message,
                "timestampMillis" to entry.timestampMillis,
                "traceId" to entry.traceId,
            )
        }
        return NativeJson.encode(list)
    }

    private fun decodeEntry(raw: Any?): NativeLogEntry? {
        if (raw !is Map<*, *>) return null
        val severityName = raw["severity"] as? String ?: return null
        val severity =
            try {
                NativeLogSeverity.valueOf(severityName)
            } catch (e: IllegalArgumentException) {
                return null
            }
        val tag = raw["tag"] as? String ?: return null
        val message = raw["message"] as? String ?: return null
        val timestamp =
            when (val ts = raw["timestampMillis"]) {
                is Long -> ts
                is Int -> ts.toLong()
                is Double -> ts.toLong()
                else -> return null
            }
        val traceId = raw["traceId"] as? String
        return NativeLogEntry(severity, tag, message, timestamp, traceId)
    }

    companion object {
        const val DEFAULT_MAX_ENTRIES = 200
        const val DEFAULT_MAX_BYTES = 64 * 1024

        /** Raw native SharedPreferences key this queue is stored under. */
        const val RAW_KEY = "com.danhdue.logger_native_bridge.queue"

        /**
         * Convenience factory for production call sites that only have a
         * [Context] on hand. See
         * [NativeAppenderToggleStore.PREFS_SUITE_NAME].
         */
        fun from(context: Context): NativeLogQueue {
            val prefs =
                context.getSharedPreferences(
                    NativeAppenderToggleStore.PREFS_SUITE_NAME,
                    Context.MODE_PRIVATE,
                )
            return NativeLogQueue(prefs)
        }
    }
}
