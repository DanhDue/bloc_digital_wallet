// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import XCTest

#if canImport(logger_native_bridge)
  import logger_native_bridge
#endif
#if canImport(native_security)
  @testable import native_security
#endif

/// Stands in for a real headless entry point (an iOS `BGTaskScheduler`
/// handler, a background fetch callback, or a Notification Service
/// Extension) — the design spec's "Headless proof" section explicitly
/// calls for a TEST FIXTURE here, not a real production task registration:
/// "a test fixture ... is enough to prove the headless path ... no
/// existing headless task exists yet". Building a real `BGTaskScheduler`
/// registration would be a separate, out-of-scope feature this epic
/// doesn't need.
///
/// The important structural property this class demonstrates: it calls
/// `D3NexusNativeLogger.e` directly, with NO `FlutterEngine`, NO Pigeon
/// channel, and NO plugin registration anywhere in scope or on the
/// classpath of this test run — proving the headless push path genuinely
/// has zero dependency on a running Flutter engine.
private struct FakeHeadlessBGTaskHandler {
  /// Mirrors what a real `BGTaskScheduler` launch handler would do: just
  /// call the facade.
  func run() {
    D3NexusNativeLogger.e("Wallet", "headless push from a simulated BGTask handler")
  }
}

/// Proves the DoD line "A log sent from a headless context (test
/// `WorkManager`/`BGTask` fixture, no `FlutterEngine` running) reaches the
/// Datadog native SDK" — at the architecture/dispatch level, per
/// `DatadogNativeAppender`'s own doc comment: it doesn't call a real SDK
/// (none exists in this repo, mirroring Task 4's Dart-side
/// `NoopDatadogLogClient` reasoning), so "reaches the Datadog native SDK"
/// is proven by showing `D3NexusNativeLogger.d/e/...()` correctly invokes
/// `DatadogNativeAppender.append` when enabled, and correctly skips it
/// when the kill switch is off — exactly mirroring the standard already
/// applied to the Dart-side `DatadogAppender` in Task 4.
final class DatadogNativeAppenderHeadlessTests: XCTestCase {
  private var defaults: UserDefaults!
  private var suiteName: String!
  private var datadog: DatadogNativeAppender!

  override func setUp() {
    super.setUp()
    D3NexusNativeLogger.resetForTest()
    suiteName = "native_security.tests.\(UUID().uuidString)"
    defaults = UserDefaults(suiteName: suiteName)

    let toggleStore = NativeAppenderToggleStore(userDefaults: defaults)
    let queue = NativeLogQueue(userDefaults: defaults)
    D3NexusNativeLogger.initialize(toggleStore: toggleStore, queue: queue)

    datadog = DatadogNativeAppender()
    D3NexusNativeLogger.registerAppender(datadog)
  }

  override func tearDown() {
    D3NexusNativeLogger.resetForTest()
    defaults.removePersistentDomain(forName: suiteName)
    super.tearDown()
  }

  func testHeadlessCallWithDatadogEnabledReachesAppenderWithNoFlutterEngineInvolved() {
    FakeHeadlessBGTaskHandler().run()

    XCTAssertEqual(datadog.delivered.count, 1)
    XCTAssertEqual(datadog.delivered.first?.message, "headless push from a simulated BGTask handler")
  }

  func testHeadlessCallAlsoLandsInQueueForLaterTalkerReplay() {
    FakeHeadlessBGTaskHandler().run()

    let queue = NativeLogQueue(userDefaults: defaults)
    let queued = queue.drainAll()

    XCTAssertEqual(queued.count, 1)
    XCTAssertEqual(queued.first?.message, "headless push from a simulated BGTask handler")
  }

  func testDisablingDatadogViaKillSwitchStopsTheHeadlessPush() {
    // Simulates Settings UI having called
    // D3NexusLogger.setAppenderEnabled('datadog', false), which Task 6
    // persists as {"datadog":false} under the flutter-prefixed raw
    // UserDefaults key this store reads.
    defaults.set("{\"datadog\":false}", forKey: NativeAppenderToggleStore.rawKey)

    FakeHeadlessBGTaskHandler().run()

    XCTAssertTrue(datadog.delivered.isEmpty, "DatadogNativeAppender must not receive the entry once disabled")
  }

  func testDisablingDatadogStillQueuesTheEntryForTalkerVisibility() {
    defaults.set("{\"datadog\":false}", forKey: NativeAppenderToggleStore.rawKey)

    FakeHeadlessBGTaskHandler().run()

    let queue = NativeLogQueue(userDefaults: defaults)
    XCTAssertEqual(
      queue.drainAll().count, 1,
      "the toggle gates live backend delivery, not local replay visibility")
  }
}
