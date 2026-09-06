package com.danhdue.{{name.snakeCase()}}.presentation

import com.danhdue.{{name.snakeCase()}}.domain.{{name.pascalCase()}}Repository
import com.danhdue.{{name.snakeCase()}}.domain.{{name.pascalCase()}}RepositoryImpl
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class {{name.pascalCase()}}ViewModel(
    private val repository: {{name.pascalCase()}}Repository = {{name.pascalCase()}}RepositoryImpl(),
    private val scope: CoroutineScope = CoroutineScope(Dispatchers.Main)
) : MviViewModel<{{name.pascalCase()}}Action, {{name.pascalCase()}}State, {{name.pascalCase()}}Event>(
    initialState = {{name.pascalCase()}}State()
) {
    override fun onAction(action: {{name.pascalCase()}}Action) {
        when (action) {
            is {{name.pascalCase()}}Action.Initialize -> {
                setState { copy(isLoading = true) }
                val data = repository.fetchData()
                setState { copy(isLoading = false, title = data) }
                scope.launch {
                    sendEvent({{name.pascalCase()}}Event.ShowToast("Loaded: $data"))
                }
            }
            is {{name.pascalCase()}}Action.Submit -> {
                setState { copy(title = action.value) }
                scope.launch {
                    sendEvent({{name.pascalCase()}}Event.ShowToast("Submitted: ${action.value}"))
                }
            }
        }
    }
}
