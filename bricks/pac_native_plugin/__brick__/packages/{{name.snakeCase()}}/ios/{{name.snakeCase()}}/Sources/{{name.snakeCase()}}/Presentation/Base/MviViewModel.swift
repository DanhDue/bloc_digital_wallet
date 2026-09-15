// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import Combine
import Foundation

/// Base ViewModel implementing the Model-View-Intent pattern for SwiftUI.
@MainActor
open class MviViewModel<State: UiState, Action: UiAction, Event: UiEvent>: ObservableObject {
    @Published public private(set) var state: State

    private let eventSubject = PassthroughSubject<Event, Never>()
    public var events: AnyPublisher<Event, Never> {
        eventSubject.eraseToAnyPublisher()
    }

    public init(initialState: State) {
        state = initialState
    }

    open func dispatch(action _: Action) {}

    public func setState(_ newState: State) {
        state = newState
    }

    public func emit(event: Event) {
        eventSubject.send(event)
    }
}
