// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import Foundation

/// Markers for MVI View Contracts.
public protocol UiState: Equatable, Sendable {}
public protocol UiAction: Sendable {}
public protocol UiEvent: Sendable {}
