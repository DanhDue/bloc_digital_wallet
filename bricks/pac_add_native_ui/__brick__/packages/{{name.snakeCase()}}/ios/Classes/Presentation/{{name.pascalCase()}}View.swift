// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import SwiftUI

public struct {{name.pascalCase()}}View: View {
    @ObservedObject public var viewModel: {{name.pascalCase()}}ViewModel

    public init(viewModel: {{name.pascalCase()}}ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: 16) {
            Text(viewModel.state.title)
                .font(.headline)
            if viewModel.state.isLoading {
                ProgressView()
            }
            Button(action: {
                viewModel.onAction(.initialize)
            }) {
                Text("Refresh Native Data")
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
