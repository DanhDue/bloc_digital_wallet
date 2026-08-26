// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import XCTest

#if canImport(logger_native_bridge)
  @testable import logger_native_bridge
#endif

final class NativeLogQueueTests: XCTestCase {
  private var defaults: UserDefaults!
  private var suiteName: String!

  override func setUp() {
    super.setUp()
    suiteName = "logger_native_bridge.tests.\(UUID().uuidString)"
    defaults = UserDefaults(suiteName: suiteName)
  }

  override func tearDown() {
    defaults.removePersistentDomain(forName: suiteName)
    super.tearDown()
  }

  private func entry(_ tag: String, _ message: String, ts: Int64 = 1000) -> NativeLogEntry {
    NativeLogEntry(severity: .debug, tag: tag, message: message, timestampMillis: ts)
  }

  func testDrainAllReturnsEntriesInFIFOOrder() {
    let queue = NativeLogQueue(userDefaults: defaults)
    queue.enqueue(entry("t1", "first"))
    queue.enqueue(entry("t2", "second"))
    queue.enqueue(entry("t3", "third"))

    let drained = queue.drainAll()

    XCTAssertEqual(drained.map { $0.message }, ["first", "second", "third"])
  }

  func testBoundedByMaxEntriesDropsOldestFirst() {
    let queue = NativeLogQueue(userDefaults: defaults, maxEntries: 3, maxBytes: 1_000_000)
    queue.enqueue(entry("t", "e1"))
    queue.enqueue(entry("t", "e2"))
    queue.enqueue(entry("t", "e3"))
    queue.enqueue(entry("t", "e4"))

    let drained = queue.drainAll()

    XCTAssertEqual(drained.count, 3)
    XCTAssertEqual(drained.map { $0.message }, ["e2", "e3", "e4"])
  }

  func testBoundedByMaxBytesDropsOldestUntilUnderLimit() {
    let queue = NativeLogQueue(userDefaults: defaults, maxEntries: 1000, maxBytes: 260)
    queue.enqueue(entry("t", String(repeating: "a", count: 50)))
    queue.enqueue(entry("t", String(repeating: "b", count: 50)))
    queue.enqueue(entry("t", String(repeating: "c", count: 50)))

    let drained = queue.drainAll()

    XCTAssertFalse(drained.contains { $0.message.hasPrefix("a") })
    XCTAssertTrue(drained.contains { $0.message.hasPrefix("c") })
  }

  func testDefaultBoundIs200Entries() {
    let queue = NativeLogQueue(userDefaults: defaults)
    for i in 0..<250 {
      queue.enqueue(entry("t", "m\(i)"))
    }

    let drained = queue.drainAll()

    XCTAssertEqual(drained.count, 200)
    XCTAssertEqual(drained.first?.message, "m50")
    XCTAssertEqual(drained.last?.message, "m249")
  }

  func testDrainAllDoesNotClearTheQueue() {
    let queue = NativeLogQueue(userDefaults: defaults)
    queue.enqueue(entry("t", "e1"))

    _ = queue.drainAll()

    XCTAssertEqual(queue.size(), 1)
  }

  func testClearEmptiesTheQueue() {
    let queue = NativeLogQueue(userDefaults: defaults)
    queue.enqueue(entry("t", "e1"))

    queue.clear()

    XCTAssertEqual(queue.size(), 0)
    XCTAssertTrue(queue.drainAll().isEmpty)
  }

  func testEmptyQueueDrainsToEmptyList() {
    let queue = NativeLogQueue(userDefaults: defaults)
    XCTAssertTrue(queue.drainAll().isEmpty)
  }

  func testPreservesOriginalTimestampAndTraceIdThroughRoundTrip() {
    let queue = NativeLogQueue(userDefaults: defaults)
    queue.enqueue(
      NativeLogEntry(
        severity: .error, tag: "wallet", message: "boom", timestampMillis: 1_700_000_000_123,
        traceId: "abc123"))

    let drained = queue.drainAll()

    XCTAssertEqual(drained.count, 1)
    XCTAssertEqual(drained[0].timestampMillis, 1_700_000_000_123)
    XCTAssertEqual(drained[0].traceId, "abc123")
    XCTAssertEqual(drained[0].severity, .error)
  }

  // --- REFACTOR checklist: replay must not duplicate across two
  // consecutive "cold starts", and must not lose entries on a failed
  // mid-replay. NativeLogBridgePlugin itself can't be unit tested (it's
  // the one Flutter/Pigeon-aware class), so this test proves the contract
  // its drain-then-clear-only-on-success logic depends on, at the
  // NativeLogQueue level, with a fake "replay" step standing in for the
  // real Pigeon FlutterApi call. ---

  func testSimulatedSuccessfulReplayClearsQueueSoSecondColdStartSeesNothing() {
    let queue = NativeLogQueue(userDefaults: defaults)
    queue.enqueue(entry("t", "e1"))
    queue.enqueue(entry("t", "e2"))

    let firstDrain = queue.drainAll()
    let firstReplaySucceeded = !firstDrain.isEmpty
    if firstReplaySucceeded { queue.clear() }

    // Cold start 2: a fresh NativeLogQueue instance over the SAME backing
    // UserDefaults suite, exactly like a process restart.
    let queueAfterRestart = NativeLogQueue(userDefaults: defaults)
    let secondDrain = queueAfterRestart.drainAll()

    XCTAssertEqual(firstDrain.count, 2)
    XCTAssertTrue(secondDrain.isEmpty, "second cold start must not re-see entries already replayed")
  }

  func testSimulatedFailedReplayLeavesEntriesQueuedForNextColdStart() {
    let queue = NativeLogQueue(userDefaults: defaults)
    queue.enqueue(entry("t", "e1"))
    queue.enqueue(entry("t", "e2"))

    let firstDrain = queue.drainAll()
    let firstReplaySucceeded = false
    if firstReplaySucceeded { queue.clear() }

    let queueAfterRestart = NativeLogQueue(userDefaults: defaults)
    let secondDrain = queueAfterRestart.drainAll()

    XCTAssertEqual(firstDrain.count, 2)
    XCTAssertEqual(secondDrain.map { $0.message }, ["e1", "e2"])
  }
}
