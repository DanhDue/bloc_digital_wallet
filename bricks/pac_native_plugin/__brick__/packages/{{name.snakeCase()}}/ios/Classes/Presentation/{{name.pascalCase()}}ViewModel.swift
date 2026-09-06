import Combine

public class {{name.pascalCase()}}ViewModel: MviViewModel<{{name.pascalCase()}}Action, {{name.pascalCase()}}State, {{name.pascalCase()}}Event> {
    private let repository: {{name.pascalCase()}}Repository

    public init(repository: {{name.pascalCase()}}Repository = {{name.pascalCase()}}RepositoryImpl()) {
        self.repository = repository
        super.init(initialState: {{name.pascalCase()}}State())
    }

    public override func onAction(_ action: {{name.pascalCase()}}Action) {
        switch action {
        case .initialize:
            setState { $0.isLoading = true }
            let data = repository.fetchData()
            setState {
                $0.isLoading = false
                $0.title = data
            }
            sendEvent(.showToast("Loaded: \(data)"))
        case .submit(let value):
            setState { $0.title = value }
            sendEvent(.showToast("Submitted: \(value)"))
        }
    }
}
