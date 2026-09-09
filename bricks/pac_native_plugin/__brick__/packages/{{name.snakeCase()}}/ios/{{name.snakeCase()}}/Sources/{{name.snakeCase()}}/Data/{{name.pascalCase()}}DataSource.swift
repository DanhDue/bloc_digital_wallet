// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import Foundation

public class {{name.pascalCase()}}DataSource: {{name.pascalCase()}}Repository {
    public init() {}

    public func getStatus() async throws -> String {
        return "Active"
    }
}
