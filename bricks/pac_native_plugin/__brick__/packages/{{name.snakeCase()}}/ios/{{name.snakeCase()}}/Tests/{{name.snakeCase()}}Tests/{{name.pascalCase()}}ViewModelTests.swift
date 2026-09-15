// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import Foundation
import XCTest
@testable import {{name.snakeCase()}}

private struct TestError: Error, LocalizedError {
    let message: String
    var errorDescription: String? {
        message
    }
}

private final class StubRepository: {{name.pascalCase()}}Repository, @unchecked Sendable {
    var stubbedData = {{name.pascalCase()}}Data(id: "stub-id", title: "Stub Title")
    var shouldThrow: Error?
    var delayNanoseconds: UInt64 = 0

    func getData() async throws -> {{name.pascalCase()}}Data {
        if delayNanoseconds > 0 {
            try await Task.sleep(nanoseconds: delayNanoseconds)
        }
        if let shouldThrow {
            throw shouldThrow
        }
        return stubbedData
    }

    func syncData() async throws {
        if let shouldThrow {
            throw shouldThrow
        }
    }
}

@MainActor
final class {{name.pascalCase()}}ViewModelTests: XCTestCase {
    func testUseCaseMapsDomainDataSuccessfully() async throws {
        let repo = StubRepository()
        let expected = {{name.pascalCase()}}Data(id: "test-id", title: "Test Domain")
        repo.stubbedData = expected
        let useCase = GetDataUseCase(repository: repo)

        let result = try await useCase.execute()
        XCTAssertEqual(result, expected)
    }

    func testUseCasePropagatesError() async {
        let repo = StubRepository()
        repo.shouldThrow = TestError(message: "Repo failed")
        let useCase = GetDataUseCase(repository: repo)

        do {
            _ = try await useCase.execute()
            XCTFail("Expected error to be thrown")
        } catch let error as TestError {
            XCTAssertEqual(error.message, "Repo failed")
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func testViewModelReducesActionsIntoState() async {
        let repo = StubRepository()
        let expected = {{name.pascalCase()}}Data(id: "mvi-id", title: "MVI Data")
        repo.stubbedData = expected
        let useCase = GetDataUseCase(repository: repo)
        let viewModel = {{name.pascalCase()}}ViewModel(getDataUseCase: useCase)

        XCTAssertEqual(viewModel.state, .idle)

        viewModel.dispatch(action: .load)
        XCTAssertEqual(viewModel.state, .loading)

        try? await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertEqual(viewModel.state, .loaded(expected))
    }

    func testViewModelHandlesErrorState() async {
        let repo = StubRepository()
        repo.shouldThrow = TestError(message: "Network broken")
        let useCase = GetDataUseCase(repository: repo)
        let viewModel = {{name.pascalCase()}}ViewModel(getDataUseCase: useCase)

        viewModel.dispatch(action: .load)

        try? await Task.sleep(nanoseconds: 50_000_000)

        if case let .error(msg) = viewModel.state {
            XCTAssertEqual(msg, "Network broken")
        } else {
            XCTFail("Expected error state, got \(viewModel.state)")
        }
    }

    func testRapidRepeatActionsDoNotRace() async {
        let repo = StubRepository()
        repo.delayNanoseconds = 100_000_000 // 100ms
        let useCase = GetDataUseCase(repository: repo)
        let viewModel = {{name.pascalCase()}}ViewModel(getDataUseCase: useCase)

        viewModel.dispatch(action: .load)
        viewModel.dispatch(action: .load)

        try? await Task.sleep(nanoseconds: 180_000_000)

        if case .loaded = viewModel.state {
            // Succeeded with single final state
        } else {
            XCTFail("Expected loaded state after repeat dispatch, got \(viewModel.state)")
        }
    }
}
