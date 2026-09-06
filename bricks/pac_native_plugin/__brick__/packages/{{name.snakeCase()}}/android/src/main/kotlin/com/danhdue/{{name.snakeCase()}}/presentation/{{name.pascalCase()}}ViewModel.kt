/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

/*
 * coverage:ignore-file
 */

package com.danhdue.{{name.snakeCase()}}.presentation

class {{name.pascalCase()}}ViewModel : MviViewModel<{{name.pascalCase()}}Action, {{name.pascalCase()}}State, {{name.pascalCase()}}Event>(
    initialState = {{name.pascalCase()}}State()
) {
    override fun onAction(action: {{name.pascalCase()}}Action) {
        when (action) {
            is {{name.pascalCase()}}Action.Initialize -> {
                setState { copy(isLoading = false) }
            }
            is {{name.pascalCase()}}Action.Submit -> {
                setState { copy(title = action.input) }
            }
        }
    }
}
