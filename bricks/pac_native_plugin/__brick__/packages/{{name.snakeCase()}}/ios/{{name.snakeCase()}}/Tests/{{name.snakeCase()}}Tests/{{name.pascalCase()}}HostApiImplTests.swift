// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import Foundation
import XCTest
@testable import {{name.snakeCase()}}

private struct HostApiTestError: Error, LocalizedError {
    let message: String
    var errorDescription: String? {
        message
    }
}

private final class StubHostRepository: {{name.pascalCase()}}Repository, @unchecked Sendable {
    var stubbedData = {{name.pascalCase()}}Data(id: "host-id", title: "Host Title")
    var shouldThrow: Error?

    func getData() async throws -> {{name.pascalCase()}}Data {
        if let shouldThrow {
            throw shouldThrow
        }
        return stubbedData
    }

    func syncData() async throws {}
}

final class {{name.pascalCase()}}HostApiImplTests: XCTestCase {
    func testHostApiDelegatesToDomainLayerSuccessfully() {
        let repo = StubHostRepository()
        let expected = {{name.pascalCase()}}Data(id: "pigeon-123", title: "Pigeon Title")
        repo.stubbedData = expected
        let useCase = GetDataUseCase(repository: repo)
        let hostApi = {{name.pascalCase()}}HostApiImpl(getDataUseCase: useCase)

        let expectation = expectation(description: "Host API callback")

        hostApi.getData { result in
            switch result {
            case let .success(message):
                XCTAssertEqual(message.id, expected.id)
                XCTAssertEqual(message.title, expected.title)
            case let .failure(error):
                XCTFail("Expected success, got error: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testHostApiSurfacesErrorsCleanly() {
        let repo = StubHostRepository()
        repo.shouldThrow = HostApiTestError(message: "Host Failure")
        let useCase = GetDataUseCase(repository: repo)
        let hostApi = {{name.pascalCase()}}HostApiImpl(getDataUseCase: useCase)

        let expectation = expectation(description: "Host API callback error")

        hostApi.getData { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case let .failure(error):
                XCTAssertEqual(error.localizedDescription, "Host Failure")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testGetPlatformVersionReturnsNonEmpty() {
        let hostApi = {{name.pascalCase()}}HostApiImpl()
        do {
            let version = try hostApi.getPlatformVersion()
            XCTAssertTrue(version.starts(with: "iOS"))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
