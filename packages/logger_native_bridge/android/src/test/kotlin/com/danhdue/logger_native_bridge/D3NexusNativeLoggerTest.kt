// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

package com.danhdue.logger_native_bridge

import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test

/** A [NativeLogAppender] test double that records every entry it receives. */
private class RecordingAppender(override val id: String) : NativeLogAppender {
    val received = mutableListOf<NativeLogEntry>()

    override fun append(entry: NativeLogEntry) {
        received.add(entry)
    }
}

class D3NexusNativeLoggerTest {
    private lateinit var prefs: FakeSharedPreferences
    private lateinit var toggleStore: NativeAppenderToggleStore
    private lateinit var queue: NativeLogQueue

    @Before
    fun setUp() {
        D3NexusNativeLogger.resetForTest()
        prefs = FakeSharedPreferences()
        toggleStore = NativeAppenderToggleStore(prefs)
        queue = NativeLogQueue(prefs)
        D3NexusNativeLogger.initialize(toggleStore, queue)
    }

    @After
    fun tearDown() {
        D3NexusNativeLogger.resetForTest()
    }

    @Test
    fun `dispatches to an enabled appender`() {
        val datadog = RecordingAppender("datadog")
        D3NexusNativeLogger.registerAppender(datadog)

        D3NexusNativeLogger.d("Wallet", "headless push")

        assertEquals(1, datadog.received.size)
        assertEquals("headless push", datadog.received.single().message)
        assertEquals(NativeLogSeverity.DEBUG, datadog.received.single().severity)
    }

    @Test
    fun `does not call an appender whose id is disabled in the toggle store`() {
        prefs.edit().putString(NativeAppenderToggleStore.RAW_KEY, """{"datadog":false}""").apply()
        val datadog = RecordingAppender("datadog")
        D3NexusNativeLogger.registerAppender(datadog)

        D3NexusNativeLogger.d("Wallet", "should be skipped")

        assertTrue(datadog.received.isEmpty())
    }

    @Test
    fun `disabling one appender does not affect a different enabled appender`() {
        prefs.edit().putString(NativeAppenderToggleStore.RAW_KEY, """{"datadog":false}""").apply()
        val datadog = RecordingAppender("datadog")
        val otel = RecordingAppender("otel")
        D3NexusNativeLogger.registerAppender(datadog)
        D3NexusNativeLogger.registerAppender(otel)

        D3NexusNativeLogger.i("Wallet", "otel should still get this")

        assertTrue(datadog.received.isEmpty())
        assertEquals(1, otel.received.size)
    }

    @Test
    fun `always enqueues into NativeLogQueue regardless of appender toggle state`() {
        prefs.edit().putString(NativeAppenderToggleStore.RAW_KEY, """{"datadog":false}""").apply()
        val datadog = RecordingAppender("datadog")
        D3NexusNativeLogger.registerAppender(datadog)

        D3NexusNativeLogger.e("Wallet", "disabled backend, but still queued for Talker replay")

        assertTrue("appender is disabled, should not receive the entry", datadog.received.isEmpty())
        val queued = queue.drainAll()
        assertEquals(1, queued.size)
        assertEquals(
            "disabled backend, but still queued for Talker replay",
            queued.single().message,
        )
    }

    @Test
    fun `enqueues even with zero registered appenders`() {
        D3NexusNativeLogger.v("Wallet", "no appenders yet")

        assertEquals(1, queue.drainAll().size)
    }

    @Test
    fun `each level maps to the matching NativeLogSeverity`() {
        val recorder = RecordingAppender("recorder")
        D3NexusNativeLogger.registerAppender(recorder)

        D3NexusNativeLogger.v("t", "v")
        D3NexusNativeLogger.d("t", "d")
        D3NexusNativeLogger.i("t", "i")
        D3NexusNativeLogger.w("t", "w")
        D3NexusNativeLogger.e("t", "e")

        assertEquals(
            listOf(
                NativeLogSeverity.VERBOSE,
                NativeLogSeverity.DEBUG,
                NativeLogSeverity.INFO,
                NativeLogSeverity.WARNING,
                NativeLogSeverity.ERROR,
            ),
            recorder.received.map { it.severity },
        )
    }

    @Test
    fun `initialize does not clear appenders registered before a later re-initialize call`() {
        val datadog = RecordingAppender("datadog")
        D3NexusNativeLogger.registerAppender(datadog)

        // Simulate NativeLogBridgePlugin.onAttachedToEngine calling
        // initialize() again after an earlier native bootstrap already did.
        D3NexusNativeLogger.initialize(toggleStore, queue)
        D3NexusNativeLogger.d("t", "still reaches datadog")

        assertEquals(1, datadog.received.size)
    }
}
