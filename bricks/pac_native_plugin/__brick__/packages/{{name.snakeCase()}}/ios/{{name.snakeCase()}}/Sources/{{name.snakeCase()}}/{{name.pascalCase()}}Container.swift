// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import FactoryKit
import Foundation

/// Dedicated Dependency Injection container for the {{name.pascalCase()}} package.
/// Subclasses `SharedContainer` so multiple plugins can co-exist without colliding on global registrations.
public final class {{name.pascalCase()}}Container: SharedContainer, @unchecked Sendable {
    public static let shared = {{name.pascalCase()}}Container()
    public let manager = ContainerManager()

    public init() {}

    public var repository: Factory<{{name.pascalCase()}}Repository> {
        self { {{name.pascalCase()}}RepositoryImpl() }
    }

    public var getDataUseCase: Factory<GetDataUseCase> {
        self { GetDataUseCase(repository: self.repository()) }
    }

    public var syncDataUseCase: Factory<SyncDataUseCase> {
        self { SyncDataUseCase(repository: self.repository()) }
    }

{{#has_ui}}
    @MainActor
    public var {{name.camelCase()}}ViewModel: Factory<{{name.pascalCase()}}ViewModel> {
        self { {{name.pascalCase()}}ViewModel(getDataUseCase: self.getDataUseCase()) }
    }
{{/has_ui}}
}
