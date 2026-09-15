// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import Foundation

/// Default implementation of {{name.pascalCase()}}Repository as an actor.
actor {{name.pascalCase()}}RepositoryImpl: {{name.pascalCase()}}Repository {
    private var currentData: {{name.pascalCase()}}Data

    init(initialData: {{name.pascalCase()}}Data? = nil) {
        currentData = initialData ?? {{name.pascalCase()}}Data(id: "default-id", title: "Native {{name.pascalCase()}} Data")
    }

    func getData() async throws -> {{name.pascalCase()}}Data {
        currentData
    }

    func syncData() async throws {
        currentData = {{name.pascalCase()}}Data(id: UUID().uuidString, title: "Synced {{name.pascalCase()}} Data", timestamp: Date())
    }
}
