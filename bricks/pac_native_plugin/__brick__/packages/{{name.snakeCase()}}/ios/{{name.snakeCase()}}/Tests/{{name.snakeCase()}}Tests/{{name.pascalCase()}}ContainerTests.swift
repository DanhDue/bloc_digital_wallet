// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import FactoryKit
import Foundation
import XCTest
@testable import {{name.snakeCase()}}

private final class Mock{{name.pascalCase()}}Repository: {{name.pascalCase()}}Repository, @unchecked Sendable {
    func getData() async throws -> {{name.pascalCase()}}Data {
        {{name.pascalCase()}}Data(id: "mock-id", title: "Mock Data")
    }

    func syncData() async throws {}
}

private final class SecondaryContainer: SharedContainer, @unchecked Sendable {
    static let shared = SecondaryContainer()
    let manager = ContainerManager()

    var repository: Factory<{{name.pascalCase()}}Repository> {
        self { Mock{{name.pascalCase()}}Repository() }
    }
}

final class {{name.pascalCase()}}ContainerTests: XCTestCase {
    override func tearDown() {
        {{name.pascalCase()}}Container.shared.manager.reset()
        super.tearDown()
    }

    func testContainerResolvesDefaultImplementation() {
        let repo = {{name.pascalCase()}}Container.shared.repository()
        XCTAssertTrue(repo is {{name.pascalCase()}}RepositoryImpl)
    }

    func testContainerCanBeOverriddenAndReset() {
        {{name.pascalCase()}}Container.shared.repository.register {
            Mock{{name.pascalCase()}}Repository()
        }

        let overridden = {{name.pascalCase()}}Container.shared.repository()
        XCTAssertTrue(overridden is Mock{{name.pascalCase()}}Repository)

        {{name.pascalCase()}}Container.shared.manager.reset()

        let restored = {{name.pascalCase()}}Container.shared.repository()
        XCTAssertTrue(restored is {{name.pascalCase()}}RepositoryImpl)
    }

    func testTwoContainersDoNotCollide() {
        let primary = {{name.pascalCase()}}Container.shared.repository()
        let secondary = SecondaryContainer.shared.repository()

        XCTAssertTrue(primary is {{name.pascalCase()}}RepositoryImpl)
        XCTAssertTrue(secondary is Mock{{name.pascalCase()}}Repository)
    }
}
