/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

package com.danhdue.{{name.snakeCase()}}.presentation

import com.danhdue.{{name.snakeCase()}}.domain.model.{{name.pascalCase()}}Data
import com.danhdue.{{name.snakeCase()}}.presentation.base.BaseAction
import com.danhdue.{{name.snakeCase()}}.presentation.base.BaseEvent
import com.danhdue.{{name.snakeCase()}}.presentation.base.BaseState

sealed interface {{name.pascalCase()}}Action : BaseAction {
    data object LoadData : {{name.pascalCase()}}Action
    data object Refresh : {{name.pascalCase()}}Action
    data object Sync : {{name.pascalCase()}}Action
}

data class {{name.pascalCase()}}State(
    val isLoading: Boolean = false,
    val data: {{name.pascalCase()}}Data? = null,
    val errorMessage: String? = null
) : BaseState

sealed interface {{name.pascalCase()}}Event : BaseEvent {
    data class ShowToast(val message: String) : {{name.pascalCase()}}Event
}
