// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import Foundation
import XCTest
@testable import {{name.snakeCase()}}

private final class MockBackgroundTask: BackgroundTaskRepresentable, @unchecked Sendable {
    var expirationHandler: (() -> Void)?
    var completedSuccess: Bool?
    private let lock = NSLock()

    func setTaskCompleted(success: Bool) {
        lock.lock()
        defer { lock.unlock() }
        completedSuccess = success
    }

    func triggerExpiration() {
        expirationHandler?()
    }
}

private final class MockSyncRepository: {{name.pascalCase()}}Repository, @unchecked Sendable {
    var syncCalled = false
    var shouldThrow = false
    var delayNanoseconds: UInt64 = 0

    func getData() async throws -> {{name.pascalCase()}}Data {
        {{name.pascalCase()}}Data(id: "sync-id", title: "Sync Data")
    }

    func syncData() async throws {
        if delayNanoseconds > 0 {
            try await Task.sleep(nanoseconds: delayNanoseconds)
        }
        if shouldThrow {
            throw NSError(domain: "SyncError", code: -1)
        }
        syncCalled = true
    }
}

final class {{name.pascalCase()}}SyncTaskTests: XCTestCase {
    func testIdentifierIsConfiguredCorrectly() {
        XCTAssertEqual({{name.pascalCase()}}SyncTask.identifier, "com.danhdue.{{name.snakeCase()}}.sync")
    }

    func testHandleTaskCompletesWithSuccessWhenUseCaseSucceeds() async {
        let repo = MockSyncRepository()
        let useCase = SyncDataUseCase(repository: repo)
        let mockTask = MockBackgroundTask()

        let work = {{name.pascalCase()}}SyncTask.handleTask(mockTask, syncUseCase: useCase)
        _ = await work.result

        XCTAssertTrue(repo.syncCalled)
        XCTAssertEqual(mockTask.completedSuccess, true)
    }

    func testHandleTaskCompletesWithFailureWhenUseCaseThrows() async {
        let repo = MockSyncRepository()
        repo.shouldThrow = true
        let useCase = SyncDataUseCase(repository: repo)
        let mockTask = MockBackgroundTask()

        let work = {{name.pascalCase()}}SyncTask.handleTask(mockTask, syncUseCase: useCase)
        _ = await work.result

        XCTAssertEqual(mockTask.completedSuccess, false)
    }

    func testExpiringBackgroundTaskCancelsCleanly() async {
        let repo = MockSyncRepository()
        repo.delayNanoseconds = 500_000_000 // 500ms
        let useCase = SyncDataUseCase(repository: repo)
        let mockTask = MockBackgroundTask()

        let work = {{name.pascalCase()}}SyncTask.handleTask(mockTask, syncUseCase: useCase)

        // Trigger expiration while in flight
        mockTask.triggerExpiration()

        _ = await work.result

        XCTAssertEqual(mockTask.completedSuccess, false)
        XCTAssertFalse(repo.syncCalled)
    }
}
