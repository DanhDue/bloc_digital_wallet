package com.danhdue.{{name.snakeCase()}}.presentation

sealed interface {{name.pascalCase()}}Event : BaseEvent {
    data class ShowToast(val message: String) : {{name.pascalCase()}}Event
}
