// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

package com.danhdue.logger_native_bridge

import android.content.Context
import android.content.SharedPreferences

/**
 * Reads the same appender kill-switch state `packages/settings` persists
 * from Dart, so a headless native call can honor
 * `D3NexusLogger.setAppenderEnabled(id, false)` without any live Pigeon
 * round-trip (see the design spec's "Kill-Switch Propagation" section).
 *
 * **Key contract** (must stay in sync with
 * `packages/settings/lib/data/datasources/local/settings_local_datasource_impl.dart`):
 * Dart writes a JSON-encoded flat `Map<String, bool>` via
 * `SharedPreferences.setString('logging.appender_toggles', ...)`. The
 * `shared_preferences` Flutter plugin transparently prefixes every key it
 * writes with `flutter.` in the underlying native `SharedPreferences` file
 * — so the RAW key this store must read is `flutter.logging.appender_toggles`,
 * NOT the bare `logging.appender_toggles` string. It also reads from the
 * exact same preferences file `shared_preferences` uses on Android: the
 * suite named `"FlutterSharedPreferences"` (see [from]).
 *
 * Both an absent key overall and an absent specific appender id within the
 * decoded map mean "enabled" (default `true`), matching
 * `LogManagerImpl`'s own `?? true` semantics on the Dart side.
 *
 * This file has zero Flutter/Pigeon dependency — [SharedPreferences] is a
 * plain Android SDK interface, not part of the Flutter embedding, and is
 * fully fakeable in a plain JVM unit test (see
 * `android/src/test/kotlin/.../NativeAppenderToggleStoreTest.kt`).
 *
 * **Per-call cost**: [D3NexusNativeLogger.log] calls [isEnabled] once per
 * registered appender, per log call — [SharedPreferences.getString] itself
 * is a cheap in-memory `HashMap` lookup (Android loads the whole prefs
 * file into memory on first access), but re-decoding the JSON toggle map
 * on every single call would not be. [readToggles] caches the last-decoded
 * map, invalidated only when the raw string actually differs from what's
 * cached — so as long as nothing else changes `RAW_KEY` between calls (the
 * common case: Dart writes it rarely, via Settings UI), repeat [isEnabled]
 * calls skip JSON decoding entirely.
 */
class NativeAppenderToggleStore(private val sharedPreferences: SharedPreferences) {
    private var cachedRawJson: String? = null
    private var cachedToggles: Map<String, Boolean> = emptyMap()

    /**
     * Whether the appender identified by [appenderId] should receive
     * headless log dispatch. Defaults to `true` (enabled) if the toggle map
     * key is absent entirely, or if [appenderId] has no explicit entry
     * within it.
     */
    fun isEnabled(appenderId: String): Boolean {
        val toggles = readToggles()
        return toggles[appenderId] ?: true
    }

    @Synchronized
    private fun readToggles(): Map<String, Boolean> {
        val json = sharedPreferences.getString(RAW_KEY, null)
        if (json == cachedRawJson) {
            // Nothing has changed under RAW_KEY since the last read: skip
            // re-decoding entirely.
            return cachedToggles
        }
        val decoded = decodeToggles(json)
        cachedRawJson = json
        cachedToggles = decoded
        return decoded
    }

    private fun decodeToggles(json: String?): Map<String, Boolean> {
        if (json == null) return emptyMap()
        return try {
            val decoded = NativeJson.decode(json)
            if (decoded !is Map<*, *>) return emptyMap()
            val result = LinkedHashMap<String, Boolean>()
            for ((k, v) in decoded) {
                if (k is String && v is Boolean) {
                    result[k] = v
                }
            }
            result
        } catch (e: NativeJsonException) {
            // Malformed/foreign value under this key: fail open (treat as
            // "no explicit toggles"), matching the Dart-side datasource's
            // own try/catch -> {} fallback.
            emptyMap()
        } catch (e: RuntimeException) {
            // Defense in depth: NativeJson.decode is contracted to only
            // ever throw NativeJsonException for malformed input, but this
            // is the exact path a headless background task depends on
            // never crashing -- fail open on any other unexpected runtime
            // exception too, rather than trust that contract absolutely.
            emptyMap()
        }
    }

    companion object {
        /**
         * The raw native SharedPreferences key, already carrying the
         * `flutter.` prefix `shared_preferences` adds transparently on the
         * Dart side. See this class's doc comment.
         */
        const val RAW_KEY = "flutter.logging.appender_toggles"

        /**
         * Name of the SharedPreferences suite `shared_preferences` backs
         * onto by default on Android.
         */
        const val PREFS_SUITE_NAME = "FlutterSharedPreferences"

        /**
         * Convenience factory for production call sites (a headless
         * `WorkManager` `Worker`'s `Context`, or [NativeLogBridgePlugin]'s
         * `FlutterPluginBinding.applicationContext`) that only have a
         * [Context] on hand. Not used by unit tests, which construct
         * [NativeAppenderToggleStore] directly from a fake
         * [SharedPreferences].
         */
        fun from(context: Context): NativeAppenderToggleStore {
            val prefs = context.getSharedPreferences(PREFS_SUITE_NAME, Context.MODE_PRIVATE)
            return NativeAppenderToggleStore(prefs)
        }
    }
}
