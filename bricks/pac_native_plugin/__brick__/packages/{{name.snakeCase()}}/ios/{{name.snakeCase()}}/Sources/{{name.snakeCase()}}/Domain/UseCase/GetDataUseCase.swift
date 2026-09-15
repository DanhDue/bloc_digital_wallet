// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import Foundation

/// Use case to fetch plugin data from the repository.
public struct GetDataUseCase: Sendable {
    private let repository: {{name.pascalCase()}}Repository

    public init(repository: {{name.pascalCase()}}Repository) {
        self.repository = repository
    }

    public func execute() async throws -> {{name.pascalCase()}}Data {
        try await repository.getData()
    }
}
