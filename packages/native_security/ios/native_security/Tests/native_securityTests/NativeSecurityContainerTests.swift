// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import FactoryKit
import XCTest

@testable import native_security

/// Phase 5 (`flutter_super_app_template`): proves the plugin's FactoryKit
/// container resolves `DatadogNativeAppender` and that a test can swap it
/// via `.register { … }` / restore with `.reset()`.
///
/// Run with `xcodebuild test` against a host that links this SPM package.
final class NativeSecurityContainerTests: XCTestCase {
  override func tearDown() {
    NativeSecurityContainer.shared.manager.reset()
    super.tearDown()
  }

  func testResolvesDefaultDatadogAppender() {
    XCTAssertEqual(NativeSecurityContainer.shared.datadogAppender().id, "datadog")
  }

  func testRegisterOverridesResolutionAndResetRestoresIt() {
    let spy = DatadogNativeAppender()
    NativeSecurityContainer.shared.datadogAppender.register { spy }
    XCTAssertTrue(NativeSecurityContainer.shared.datadogAppender() === spy)

    NativeSecurityContainer.shared.datadogAppender.reset()
    XCTAssertFalse(NativeSecurityContainer.shared.datadogAppender() === spy)
  }
}
