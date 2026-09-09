// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import XCTest

#if canImport(logger_native_bridge)
  @testable import logger_native_bridge
#endif

/// A `NativeLogAppender` test double that records every entry it receives.
private final class RecordingAppender: NativeLogAppender {
  let id: String
  private(set) var received: [NativeLogEntry] = []

  init(_ id: String) {
    self.id = id
  }

  func append(_ entry: NativeLogEntry) {
    received.append(entry)
  }
}

final class D3NexusNativeLoggerTests: XCTestCase {
  private var defaults: UserDefaults!
  private var suiteName: String!
  private var toggleStore: NativeAppenderToggleStore!
  private var queue: NativeLogQueue!

  override func setUp() {
    super.setUp()
    D3NexusNativeLogger.resetForTest()
    suiteName = "logger_native_bridge.tests.\(UUID().uuidString)"
    defaults = UserDefaults(suiteName: suiteName)
    toggleStore = NativeAppenderToggleStore(userDefaults: defaults)
    queue = NativeLogQueue(userDefaults: defaults)
    D3NexusNativeLogger.initialize(toggleStore: toggleStore, queue: queue)
  }

  override func tearDown() {
    D3NexusNativeLogger.resetForTest()
    defaults.removePersistentDomain(forName: suiteName)
    super.tearDown()
  }

  func testDispatchesToAnEnabledAppender() {
    let datadog = RecordingAppender("datadog")
    D3NexusNativeLogger.registerAppender(datadog)

    D3NexusNativeLogger.d("Wallet", "headless push")

    XCTAssertEqual(datadog.received.count, 1)
    XCTAssertEqual(datadog.received.first?.message, "headless push")
    XCTAssertEqual(datadog.received.first?.severity, .debug)
  }

  func testDoesNotCallAnAppenderWhoseIdIsDisabledInTheToggleStore() {
    defaults.set("{\"datadog\":false}", forKey: NativeAppenderToggleStore.rawKey)
    let datadog = RecordingAppender("datadog")
    D3NexusNativeLogger.registerAppender(datadog)

    D3NexusNativeLogger.d("Wallet", "should be skipped")

    XCTAssertTrue(datadog.received.isEmpty)
  }

  func testDisablingOneAppenderDoesNotAffectAnotherEnabledAppender() {
    defaults.set("{\"datadog\":false}", forKey: NativeAppenderToggleStore.rawKey)
    let datadog = RecordingAppender("datadog")
    let otel = RecordingAppender("otel")
    D3NexusNativeLogger.registerAppender(datadog)
    D3NexusNativeLogger.registerAppender(otel)

    D3NexusNativeLogger.i("Wallet", "otel should still get this")

    XCTAssertTrue(datadog.received.isEmpty)
    XCTAssertEqual(otel.received.count, 1)
  }

  func testAlwaysEnqueuesRegardlessOfAppenderToggleState() {
    defaults.set("{\"datadog\":false}", forKey: NativeAppenderToggleStore.rawKey)
    let datadog = RecordingAppender("datadog")
    D3NexusNativeLogger.registerAppender(datadog)

    D3NexusNativeLogger.e("Wallet", "disabled backend, but still queued for Talker replay")

    XCTAssertTrue(datadog.received.isEmpty, "appender is disabled, should not receive the entry")
    let queued = queue.drainAll()
    XCTAssertEqual(queued.count, 1)
    XCTAssertEqual(queued.first?.message, "disabled backend, but still queued for Talker replay")
  }

  func testEnqueuesEvenWithZeroRegisteredAppenders() {
    D3NexusNativeLogger.v("Wallet", "no appenders yet")
    XCTAssertEqual(queue.drainAll().count, 1)
  }

  func testEachLevelMapsToMatchingSeverity() {
    let recorder = RecordingAppender("recorder")
    D3NexusNativeLogger.registerAppender(recorder)

    D3NexusNativeLogger.v("t", "v")
    D3NexusNativeLogger.d("t", "d")
    D3NexusNativeLogger.i("t", "i")
    D3NexusNativeLogger.w("t", "w")
    D3NexusNativeLogger.e("t", "e")

    XCTAssertEqual(
      recorder.received.map { $0.severity },
      [.verbose, .debug, .info, .warning, .error]
    )
  }

  func testInitializeDoesNotClearAppendersRegisteredBeforeALaterReinitializeCall() {
    let datadog = RecordingAppender("datadog")
    D3NexusNativeLogger.registerAppender(datadog)

    // Simulates NativeLogBridgePlugin.register(with:) calling initialize()
    // again after an earlier native bootstrap already did.
    D3NexusNativeLogger.initialize(toggleStore: toggleStore, queue: queue)
    D3NexusNativeLogger.d("t", "still reaches datadog")

    XCTAssertEqual(datadog.received.count, 1)
  }
}
