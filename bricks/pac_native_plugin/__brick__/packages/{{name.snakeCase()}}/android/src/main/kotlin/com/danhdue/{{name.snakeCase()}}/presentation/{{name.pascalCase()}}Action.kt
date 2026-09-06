package com.danhdue.{{name.snakeCase()}}.presentation

sealed interface {{name.pascalCase()}}Action : BaseAction {
    data object Initialize : {{name.pascalCase()}}Action
    data class Submit(val input: String) : {{name.pascalCase()}}Action
}
