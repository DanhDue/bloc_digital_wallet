// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

package com.danhdue.logger_native_bridge

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class NativeLogQueueTest {
    private fun entry(tag: String, message: String, ts: Long = 1000L) =
        NativeLogEntry(NativeLogSeverity.DEBUG, tag, message, ts)

    @Test
    fun `drainAll returns entries in FIFO order`() {
        val prefs = FakeSharedPreferences()
        val queue = NativeLogQueue(prefs)

        queue.enqueue(entry("t1", "first"))
        queue.enqueue(entry("t2", "second"))
        queue.enqueue(entry("t3", "third"))

        val drained = queue.drainAll()

        assertEquals(listOf("first", "second", "third"), drained.map { it.message })
    }

    @Test
    fun `bounded by maxEntries drops the oldest entry first`() {
        val prefs = FakeSharedPreferences()
        val queue = NativeLogQueue(prefs, maxEntries = 3, maxBytes = 1_000_000)

        queue.enqueue(entry("t", "e1"))
        queue.enqueue(entry("t", "e2"))
        queue.enqueue(entry("t", "e3"))
        queue.enqueue(entry("t", "e4"))

        val drained = queue.drainAll()

        assertEquals(3, drained.size)
        assertEquals(listOf("e2", "e3", "e4"), drained.map { it.message })
    }

    @Test
    fun `bounded by maxBytes drops oldest entries until under the byte limit`() {
        val prefs = FakeSharedPreferences()
        // A tiny byte budget forces the bound to trigger on size, not count.
        val queue = NativeLogQueue(prefs, maxEntries = 1_000, maxBytes = 220)

        queue.enqueue(entry("t", "a".repeat(50)))
        queue.enqueue(entry("t", "b".repeat(50)))
        queue.enqueue(entry("t", "c".repeat(50)))

        val drained = queue.drainAll()

        // Oldest ("a"*50) must have been dropped to stay under maxBytes.
        assertTrue(drained.none { it.message.startsWith("a") })
        assertTrue(drained.any { it.message.startsWith("c") })
    }

    @Test
    fun `default bound is 200 entries`() {
        val prefs = FakeSharedPreferences()
        val queue = NativeLogQueue(prefs)

        repeat(250) { i -> queue.enqueue(entry("t", "m$i")) }

        val drained = queue.drainAll()

        assertEquals(200, drained.size)
        // The 50 oldest (m0..m49) were dropped; m50..m249 remain, in order.
        assertEquals("m50", drained.first().message)
        assertEquals("m249", drained.last().message)
    }

    @Test
    fun `drainAll does not clear the queue`() {
        val prefs = FakeSharedPreferences()
        val queue = NativeLogQueue(prefs)
        queue.enqueue(entry("t", "e1"))

        queue.drainAll()

        assertEquals(1, queue.size())
    }

    @Test
    fun `clear empties the queue`() {
        val prefs = FakeSharedPreferences()
        val queue = NativeLogQueue(prefs)
        queue.enqueue(entry("t", "e1"))

        queue.clear()

        assertEquals(0, queue.size())
        assertTrue(queue.drainAll().isEmpty())
    }

    @Test
    fun `empty queue drains to an empty list`() {
        val prefs = FakeSharedPreferences()
        val queue = NativeLogQueue(prefs)

        assertTrue(queue.drainAll().isEmpty())
    }

    @Test
    fun `malformed numeric field fails open instead of throwing`() {
        // A lone '-' (or "1e" with no exponent digits) previously reached
        // text.toDouble() unguarded in NativeJson's number parser and
        // threw a raw NumberFormatException past NativeJson.decode --
        // exactly the kind of crash the "fail open" contract exists to
        // prevent on a headless background thread.
        val prefs =
            FakeSharedPreferences(
                mapOf(
                    NativeLogQueue.RAW_KEY to
                        """[{"severity":"DEBUG","tag":"t","message":"m","timestampMillis":-,"traceId":null}]""",
                ),
            )
        val queue = NativeLogQueue(prefs)

        // Must not throw. The whole document fails to decode, so this
        // fails open to an empty queue rather than crashing the caller.
        assertTrue(queue.drainAll().isEmpty())
    }

    @Test
    fun `preserves original timestamp and traceId through enqueue-drain round trip`() {
        val prefs = FakeSharedPreferences()
        val queue = NativeLogQueue(prefs)

        queue.enqueue(
            NativeLogEntry(NativeLogSeverity.ERROR, "wallet", "boom", 1_700_000_000_123L, "abc123"),
        )

        val drained = queue.drainAll().single()

        assertEquals(1_700_000_000_123L, drained.timestampMillis)
        assertEquals("abc123", drained.traceId)
        assertEquals(NativeLogSeverity.ERROR, drained.severity)
    }

    // --- REFACTOR checklist: replay must not duplicate across two
    // consecutive "cold starts", and must not lose entries on a failed
    // mid-replay. NativeLogBridgePlugin itself can't be unit tested (it's
    // the one Flutter/Pigeon-aware class), so this test proves the
    // contract its drain-then-clear-only-on-success logic depends on, at
    // the NativeLogQueue level, with a fake "replay" step standing in for
    // the real Pigeon FlutterApi call. ---

    @Test
    fun `simulated successful replay clears the queue so a second cold start sees nothing`() {
        val prefs = FakeSharedPreferences()
        val queue = NativeLogQueue(prefs)
        queue.enqueue(entry("t", "e1"))
        queue.enqueue(entry("t", "e2"))

        // Cold start 1: drain, "replay" every entry successfully, then clear.
        val firstDrain = queue.drainAll()
        val firstReplaySucceeded = firstDrain.isNotEmpty() // stand-in for "every onNativeLog callback succeeded"
        if (firstReplaySucceeded) queue.clear()

        // Cold start 2: a fresh NativeLogQueue instance over the SAME
        // backing SharedPreferences, exactly like a process restart.
        val queueAfterRestart = NativeLogQueue(prefs)
        val secondDrain = queueAfterRestart.drainAll()

        assertEquals(2, firstDrain.size)
        assertTrue("second cold start must not re-see entries already replayed", secondDrain.isEmpty())
    }

    @Test
    fun `simulated failed replay leaves entries queued for the next cold start`() {
        val prefs = FakeSharedPreferences()
        val queue = NativeLogQueue(prefs)
        queue.enqueue(entry("t", "e1"))
        queue.enqueue(entry("t", "e2"))

        // Cold start 1: drain, but the "replay" fails (e.g. process killed
        // mid-replay) -- clear() must NOT be called in this branch.
        val firstDrain = queue.drainAll()
        val firstReplaySucceeded = false
        if (firstReplaySucceeded) queue.clear()

        // Cold start 2: the unreplayed entries are still there, in order,
        // and are NOT duplicated (still exactly the original 2, not 4).
        val queueAfterRestart = NativeLogQueue(prefs)
        val secondDrain = queueAfterRestart.drainAll()

        assertEquals(2, firstDrain.size)
        assertEquals(listOf("e1", "e2"), secondDrain.map { it.message })
    }
}
