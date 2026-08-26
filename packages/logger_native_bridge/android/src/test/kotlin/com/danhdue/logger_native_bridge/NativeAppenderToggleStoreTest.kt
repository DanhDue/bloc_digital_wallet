// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

package com.danhdue.logger_native_bridge

import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class NativeAppenderToggleStoreTest {
    @Test
    fun `returns true when the raw key is entirely absent`() {
        val store = NativeAppenderToggleStore(FakeSharedPreferences())

        assertTrue(store.isEnabled("datadog"))
    }

    @Test
    fun `returns true when the appender id has no explicit entry in the map`() {
        val prefs =
            FakeSharedPreferences(
                mapOf(NativeAppenderToggleStore.RAW_KEY to """{"talker":true}"""),
            )
        val store = NativeAppenderToggleStore(prefs)

        assertTrue(store.isEnabled("datadog"))
    }

    @Test
    fun `returns false when explicitly disabled`() {
        val prefs =
            FakeSharedPreferences(
                mapOf(NativeAppenderToggleStore.RAW_KEY to """{"datadog":false}"""),
            )
        val store = NativeAppenderToggleStore(prefs)

        assertFalse(store.isEnabled("datadog"))
    }

    @Test
    fun `returns true when explicitly enabled`() {
        val prefs =
            FakeSharedPreferences(
                mapOf(NativeAppenderToggleStore.RAW_KEY to """{"datadog":true,"otel":false}"""),
            )
        val store = NativeAppenderToggleStore(prefs)

        assertTrue(store.isEnabled("datadog"))
        assertFalse(store.isEnabled("otel"))
    }

    @Test
    fun `reads the flutter-prefixed raw key, not the bare Dart-side key`() {
        // Writing under the BARE 'logging.appender_toggles' key (as if
        // someone mistakenly skipped the shared_preferences 'flutter.'
        // prefix) must NOT be picked up -- this is the exact bug the task
        // brief calls out as "silently never works" if gotten wrong.
        val prefs =
            FakeSharedPreferences(
                mapOf("logging.appender_toggles" to """{"datadog":false}"""),
            )
        val store = NativeAppenderToggleStore(prefs)

        assertTrue("must default to enabled; the bare key must be ignored", store.isEnabled("datadog"))
    }

    @Test
    fun `raw key constant carries the flutter dot prefix shared_preferences adds`() {
        assertTrue(NativeAppenderToggleStore.RAW_KEY.startsWith("flutter."))
        assertTrue(NativeAppenderToggleStore.RAW_KEY.endsWith("logging.appender_toggles"))
    }

    @Test
    fun `malformed JSON under the key fails open to enabled`() {
        val prefs =
            FakeSharedPreferences(
                mapOf(NativeAppenderToggleStore.RAW_KEY to "not valid json{{{"),
            )
        val store = NativeAppenderToggleStore(prefs)

        assertTrue(store.isEnabled("datadog"))
    }

    @Test
    fun `malformed unicode escape fails open instead of throwing`() {
        // A non-hex \u escape previously reached hex.toInt(16) unguarded
        // and threw a raw NumberFormatException past NativeJson.decode --
        // exactly the kind of crash the "fail open" contract exists to
        // prevent on a headless background thread. \\uZZZZ below is the
        // literal JSON text `\uZZZZ` (not a real escape sequence).
        val prefs =
            FakeSharedPreferences(
                mapOf(NativeAppenderToggleStore.RAW_KEY to """{"\uZZZZ":true,"datadog":false}"""),
            )
        val store = NativeAppenderToggleStore(prefs)

        // Must not throw. Since the whole document fails to decode, this
        // fails open to "no explicit toggles" -- datadog defaults enabled,
        // same as any other malformed-JSON case.
        assertTrue(store.isEnabled("datadog"))
    }
}
