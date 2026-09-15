// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import Foundation

/// State representation for {{name.pascalCase()}}View.
public enum {{name.pascalCase()}}State: UiState {
    case idle
    case loading
    case loaded({{name.pascalCase()}}Data)
    case error(String)
}
