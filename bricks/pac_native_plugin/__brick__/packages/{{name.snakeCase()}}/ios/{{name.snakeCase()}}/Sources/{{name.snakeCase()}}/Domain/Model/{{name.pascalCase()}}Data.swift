// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import Foundation

/// Domain model representing data handled by the plugin.
public struct {{name.pascalCase()}}Data: Equatable, Sendable {
    public let id: String
    public let title: String
    public let timestamp: Date

    public init(id: String, title: String, timestamp: Date = Date()) {
        self.id = id
        self.title = title
        self.timestamp = timestamp
    }
}
