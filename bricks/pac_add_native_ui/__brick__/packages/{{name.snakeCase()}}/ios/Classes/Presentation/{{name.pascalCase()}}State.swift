// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

public struct {{name.pascalCase()}}State: BaseState {
    public var isLoading: Bool = false
    public var title: String = "{{name.pascalCase()}} Native UI"
    public var error: String? = nil

    public init(isLoading: Bool = false, title: String = "{{name.pascalCase()}} Native UI", error: String? = nil) {
        self.isLoading = isLoading
        self.title = title
        self.error = error
    }
}
