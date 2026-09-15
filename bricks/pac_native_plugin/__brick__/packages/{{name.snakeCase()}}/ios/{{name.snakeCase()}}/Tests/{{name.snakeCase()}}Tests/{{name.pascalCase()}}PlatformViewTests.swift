// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import Flutter
import Foundation
import UIKit
import XCTest
@testable import {{name.snakeCase()}}

@MainActor
final class {{name.pascalCase()}}PlatformViewTests: XCTestCase {
    func testFactoryCreatesPlatformViewWithValidUIView() {
        let factory = {{name.pascalCase()}}PlatformViewFactory()

        let platformView = factory.create(
            withFrame: CGRect(x: 0, y: 0, width: 320, height: 480),
            viewIdentifier: 42,
            arguments: nil
        )

        XCTAssertTrue(platformView is {{name.pascalCase()}}PlatformView)
        let uiView = platformView.view()
        XCTAssertNotNil(uiView)
        XCTAssertEqual(uiView.frame.width, 320)
        XCTAssertEqual(uiView.frame.height, 480)
    }

    func testPlatformViewRetainsHostingController() {
        let platformView = {{name.pascalCase()}}PlatformView(
            frame: .zero,
            viewIdentifier: 1,
            arguments: nil
        )

        XCTAssertNotNil(platformView.hostingController)
        XCTAssertNotNil(platformView.view())
    }
}
