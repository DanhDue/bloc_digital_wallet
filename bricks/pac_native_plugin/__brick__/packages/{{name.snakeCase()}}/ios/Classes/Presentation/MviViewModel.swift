import Combine
import SwiftUI

public protocol BaseAction {}
public protocol BaseState {}
public protocol BaseEvent {}

open class MviViewModel<A: BaseAction, S: BaseState, E: BaseEvent>: ObservableObject {
    @Published public private(set) var state: S
    private let eventSubject = PassthroughSubject<E, Never>()
    public var events: AnyPublisher<E, Never> {
        eventSubject.eraseToAnyPublisher()
    }

    public init(initialState: S) {
        self.state = initialState
    }

    public func setState(_ update: (inout S) -> Void) {
        var newState = self.state
        update(&newState)
        self.state = newState
    }

    public func sendEvent(_ event: E) {
        eventSubject.send(event)
    }

    open func onAction(_ action: A) {
        // Override in subclass
    }
}
