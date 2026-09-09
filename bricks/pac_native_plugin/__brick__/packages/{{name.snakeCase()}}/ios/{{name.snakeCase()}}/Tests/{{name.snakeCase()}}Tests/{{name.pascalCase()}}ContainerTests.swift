// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import FactoryKit
import XCTest

@testable import {{name.snakeCase()}}

/// Proves the plugin's FactoryKit container resolves its `repository` and that
/// a test can swap it with `.register { … }` and restore it with `.reset()`.
///
/// Runs with `xcodebuild test` against a host that links this SPM package
/// (there is no standalone `swift test` — the package depends on the
/// Flutter-generated `FlutterFramework`).
final class {{name.pascalCase()}}ContainerTests: XCTestCase {
    override func tearDown() {
        {{name.pascalCase()}}Container.shared.manager.reset()
        super.tearDown()
    }

    func testResolvesDefaultRepository() {
        XCTAssertNotNil({{name.pascalCase()}}Container.shared.repository())
    }

    func testRegisterOverridesResolutionAndResetRestoresIt() {
        final class Fake{{name.pascalCase()}}Repository: {{name.pascalCase()}}Repository {
            func getStatus() async throws -> String { "fake" }
        }
        let fake = Fake{{name.pascalCase()}}Repository()
        {{name.pascalCase()}}Container.shared.repository.register { fake }
        XCTAssertTrue({{name.pascalCase()}}Container.shared.repository() is Fake{{name.pascalCase()}}Repository)

        {{name.pascalCase()}}Container.shared.repository.reset()
        XCTAssertFalse({{name.pascalCase()}}Container.shared.repository() is Fake{{name.pascalCase()}}Repository)
    }
}
