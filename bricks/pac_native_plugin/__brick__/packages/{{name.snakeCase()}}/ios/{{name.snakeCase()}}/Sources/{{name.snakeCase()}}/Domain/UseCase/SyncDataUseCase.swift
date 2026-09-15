// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import Foundation

/// Use case to trigger data synchronization via the repository.
public struct SyncDataUseCase: Sendable {
    private let repository: {{name.pascalCase()}}Repository

    public init(repository: {{name.pascalCase()}}Repository) {
        self.repository = repository
    }

    public func execute() async throws {
        try await repository.syncData()
    }
}
