// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import Foundation

/// ViewModel for {{name.pascalCase()}} screen handling MVI state reduction.
@MainActor
public final class {{name.pascalCase()}}ViewModel: MviViewModel<{{name.pascalCase()}}State, {{name.pascalCase()}}Action, {{name.pascalCase()}}Event> {
    private let getDataUseCase: GetDataUseCase
    private var inFlightTask: Task<Void, Never>?

    public init(getDataUseCase: GetDataUseCase = {{name.pascalCase()}}Container.shared.getDataUseCase()) {
        self.getDataUseCase = getDataUseCase
        super.init(initialState: .idle)
    }

    override public func dispatch(action: {{name.pascalCase()}}Action) {
        switch action {
        case .load, .refresh:
            loadData()
        }
    }

    private func loadData() {
        inFlightTask?.cancel()
        setState(.loading)

        inFlightTask = Task { [weak self] in
            guard let self else { return }
            do {
                try Task.checkCancellation()
                let data = try await getDataUseCase.execute()
                try Task.checkCancellation()
                setState(.loaded(data))
            } catch is CancellationError {
                // Task was cancelled by repeat action
            } catch {
                setState(.error(error.localizedDescription))
                emit(event: .showError(error.localizedDescription))
            }
        }
    }

    deinit {
        inFlightTask?.cancel()
    }
}
