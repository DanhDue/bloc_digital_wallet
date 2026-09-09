// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import XCTest

#if canImport(logger_native_bridge)
  @testable import logger_native_bridge
#endif

final class NativeAppenderToggleStoreTests: XCTestCase {
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

  func testReturnsTrueWhenTheRawKeyIsEntirelyAbsent() {
    let store = NativeAppenderToggleStore(userDefaults: defaults)
    XCTAssertTrue(store.isEnabled("datadog"))
  }

  func testReturnsTrueWhenAppenderIdHasNoExplicitEntry() {
    defaults.set("{\"talker\":true}", forKey: NativeAppenderToggleStore.rawKey)
    let store = NativeAppenderToggleStore(userDefaults: defaults)

    XCTAssertTrue(store.isEnabled("datadog"))
  }

  func testReturnsFalseWhenExplicitlyDisabled() {
    defaults.set("{\"datadog\":false}", forKey: NativeAppenderToggleStore.rawKey)
    let store = NativeAppenderToggleStore(userDefaults: defaults)

    XCTAssertFalse(store.isEnabled("datadog"))
  }

  func testReturnsTrueWhenExplicitlyEnabled() {
    defaults.set("{\"datadog\":true,\"otel\":false}", forKey: NativeAppenderToggleStore.rawKey)
    let store = NativeAppenderToggleStore(userDefaults: defaults)

    XCTAssertTrue(store.isEnabled("datadog"))
    XCTAssertFalse(store.isEnabled("otel"))
  }

  func testReadsTheFlutterPrefixedRawKeyNotTheBareDartSideKey() {
    // Writing under the BARE 'logging.appender_toggles' key must NOT be
    // picked up -- this is the exact bug the task brief calls out as
    // "silently never works" if gotten wrong.
    defaults.set("{\"datadog\":false}", forKey: "logging.appender_toggles")
    let store = NativeAppenderToggleStore(userDefaults: defaults)

    XCTAssertTrue(store.isEnabled("datadog"), "must default to enabled; the bare key must be ignored")
  }

  func testRawKeyConstantCarriesTheFlutterDotPrefix() {
    XCTAssertTrue(NativeAppenderToggleStore.rawKey.hasPrefix("flutter."))
    XCTAssertTrue(NativeAppenderToggleStore.rawKey.hasSuffix("logging.appender_toggles"))
  }

  func testMalformedJSONUnderTheKeyFailsOpenToEnabled() {
    defaults.set("not valid json{{{", forKey: NativeAppenderToggleStore.rawKey)
    let store = NativeAppenderToggleStore(userDefaults: defaults)

    XCTAssertTrue(store.isEnabled("datadog"))
  }

  func testNumericValueIsNotMisreadAsBoolean() {
    // Guards the NSNumber/Bool bridging footgun: a JSON number under the
    // key must not be silently treated as a boolean toggle value.
    defaults.set("{\"datadog\":1}", forKey: NativeAppenderToggleStore.rawKey)
    let store = NativeAppenderToggleStore(userDefaults: defaults)

    XCTAssertTrue(store.isEnabled("datadog"), "a non-boolean value must fall back to the default (enabled)")
  }
}
