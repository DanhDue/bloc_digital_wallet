// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import FactoryKit
import XCTest

@testable import logger_native_bridge

/// Phase 5 (`flutter_super_app_template`): proves the plugin's FactoryKit
/// container resolves the two `UserDefaults`-backed collaborators and that
/// a test can swap them via `.register { … }` / restore with `.reset()`.
///
/// Run with `xcodebuild test` against a host that links this SPM package
/// (there is no standalone `swift test` here — the package depends on the
/// Flutter-generated `FlutterFramework`).
final class LoggerNativeBridgeContainerTests: XCTestCase {
  override func tearDown() {
    LoggerNativeBridgeContainer.shared.manager.reset()
    super.tearDown()
  }

  func testResolvesDefaultCollaborators() {
    XCTAssertNotNil(LoggerNativeBridgeContainer.shared.toggleStore())
    XCTAssertNotNil(LoggerNativeBridgeContainer.shared.logQueue())
  }

  func testRegisterOverridesResolutionAndResetRestoresIt() {
    let suite = "logger_native_bridge.tests.\(UUID().uuidString)"
    let defaults = UserDefaults(suiteName: suite)!
    let spy = NativeLogQueue(userDefaults: defaults)

    LoggerNativeBridgeContainer.shared.logQueue.register { spy }
    XCTAssertTrue(LoggerNativeBridgeContainer.shared.logQueue() === spy)

    LoggerNativeBridgeContainer.shared.logQueue.reset()
    XCTAssertFalse(LoggerNativeBridgeContainer.shared.logQueue() === spy)

    defaults.removePersistentDomain(forName: suite)
  }
}
