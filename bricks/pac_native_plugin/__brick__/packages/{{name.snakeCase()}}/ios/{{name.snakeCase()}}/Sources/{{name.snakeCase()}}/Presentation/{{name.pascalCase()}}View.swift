// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import SwiftUI

/// Standalone SwiftUI view rendering the plugin UI.
public struct {{name.pascalCase()}}View: View {
    @StateObject private var viewModel: {{name.pascalCase()}}ViewModel

    public init(viewModel: {{name.pascalCase()}}ViewModel? = nil) {
        let resolvedViewModel = viewModel ?? {{name.pascalCase()}}Container.shared.{{name.camelCase()}}ViewModel()
        _viewModel = StateObject(wrappedValue: resolvedViewModel)
    }

    public var body: some View {
        VStack(spacing: 16) {
            switch viewModel.state {
            case .idle:
                Text("Idle")
                    .foregroundColor(.secondary)
            case .loading:
                ProgressView("Loading {{name.pascalCase()}} data...")
            case let .loaded(data):
                Text(data.title)
                    .font(.headline)
                Text("ID: \(data.id)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Button("Refresh") {
                    viewModel.dispatch(action: .refresh)
                }
            case let .error(message):
                Text("Error: \(message)")
                    .foregroundColor(.red)
                Button("Retry") {
                    viewModel.dispatch(action: .load)
                }
            }
        }
        .padding()
        .onAppear {
            if viewModel.state == .idle {
                viewModel.dispatch(action: .load)
            }
        }
    }
}
