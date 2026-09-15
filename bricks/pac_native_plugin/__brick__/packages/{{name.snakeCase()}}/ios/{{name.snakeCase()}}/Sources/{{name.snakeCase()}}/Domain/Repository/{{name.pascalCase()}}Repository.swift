// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import Foundation

/// Repository protocol for plugin domain operations.
public protocol {{name.pascalCase()}}Repository: Sendable {
    func getData() async throws -> {{name.pascalCase()}}Data
    func syncData() async throws
}
