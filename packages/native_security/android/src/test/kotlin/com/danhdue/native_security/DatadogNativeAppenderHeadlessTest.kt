// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

package com.danhdue.native_security

import com.danhdue.logger_native_bridge.D3NexusNativeLogger
import com.danhdue.logger_native_bridge.NativeAppenderToggleStore
import com.danhdue.logger_native_bridge.NativeLogQueue
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test

/**
 * Stands in for a real headless entry point (an Android `WorkManager`
 * `Worker.doWork()`, a `BroadcastReceiver.onReceive()`, or a foreground
 * `Service`) — the design spec's "Headless proof" section explicitly calls
 * for a TEST FIXTURE here, not a real production `Worker` class: "a test
 * fixture ... is enough to prove the headless path ... no existing
 * headless task exists yet". Building a real `WorkManager` `Worker`
 * registration would be a separate, out-of-scope feature this epic
 * doesn't need.
 *
 * The important structural property this class demonstrates: it calls
 * [D3NexusNativeLogger.d] directly, with NO `FlutterEngine`, NO Pigeon
 * channel, and NO plugin registration anywhere in scope or on the
 * classpath of this test run — proving the headless push path genuinely
 * has zero dependency on a running Flutter engine.
 */
private class FakeHeadlessWorker {
    /** Mirrors what a real `Worker.doWork()` would do: just call the facade. */
    fun doWork() {
        D3NexusNativeLogger.e("Wallet", "headless push from a simulated background Worker")
    }
}

/**
 * Proves the DoD line "A log sent from a headless context (test
 * `WorkManager`/`BGTask` fixture, no `FlutterEngine` running) reaches the
 * Datadog native SDK" — at the architecture/dispatch level, per this
 * class's own doc comment: [DatadogNativeAppender] doesn't call a real SDK
 * (none exists in this repo, mirroring Task 4's Dart-side
 * `NoopDatadogLogClient` reasoning), so "reaches the Datadog native SDK"
 * is proven by showing `D3NexusNativeLogger.d/e/...()` correctly invokes
 * [DatadogNativeAppender.append] when enabled, and correctly skips it when
 * the kill switch is off — exactly mirroring the standard already applied
 * to the Dart-side `DatadogAppender` in Task 4.
 */
class DatadogNativeAppenderHeadlessTest {
    private lateinit var prefs: FakeSharedPreferences
    private lateinit var datadog: DatadogNativeAppender

    @Before
    fun setUp() {
        D3NexusNativeLogger.resetForTest()
        prefs = FakeSharedPreferences()
        val toggleStore = NativeAppenderToggleStore(prefs)
        val queue = NativeLogQueue(prefs)
        D3NexusNativeLogger.initialize(toggleStore, queue)

        datadog = DatadogNativeAppender()
        D3NexusNativeLogger.registerAppender(datadog)
    }

    @After
    fun tearDown() {
        D3NexusNativeLogger.resetForTest()
    }

    @Test
    fun `headless call with datadog enabled reaches DatadogNativeAppender with no FlutterEngine involved`() {
        FakeHeadlessWorker().doWork()

        assertEquals(1, datadog.delivered.size)
        assertEquals(
            "headless push from a simulated background Worker",
            datadog.delivered.single().message,
        )
    }

    @Test
    fun `headless call also lands in NativeLogQueue for later Talker replay`() {
        FakeHeadlessWorker().doWork()

        val queue = NativeLogQueue(prefs)
        val queued = queue.drainAll()

        assertEquals(1, queued.size)
        assertEquals(
            "headless push from a simulated background Worker",
            queued.single().message,
        )
    }

    @Test
    fun `disabling the datadog appender via the kill switch stops the headless push`() {
        // Simulates Settings UI having called
        // D3NexusLogger.setAppenderEnabled('datadog', false), which Task 6
        // persists as {"datadog":false} under the flutter-prefixed raw
        // SharedPreferences key this store reads.
        prefs
            .edit()
            .putString(NativeAppenderToggleStore.RAW_KEY, """{"datadog":false}""")
            .apply()

        FakeHeadlessWorker().doWork()

        assertTrue(
            "DatadogNativeAppender must not receive the entry once disabled",
            datadog.delivered.isEmpty(),
        )
    }

    @Test
    fun `disabling datadog still queues the entry for Talker visibility`() {
        prefs
            .edit()
            .putString(NativeAppenderToggleStore.RAW_KEY, """{"datadog":false}""")
            .apply()

        FakeHeadlessWorker().doWork()

        val queue = NativeLogQueue(prefs)
        assertEquals(
            "the toggle gates live backend delivery, not local replay visibility",
            1,
            queue.drainAll().size,
        )
    }
}
