package com.danhdue.{{name.snakeCase()}}.presentation

data class {{name.pascalCase()}}State(
    val isLoading: Boolean = false,
    val title: String = "{{name.pascalCase()}} Native UI",
    val error: String? = null
) : BaseState
