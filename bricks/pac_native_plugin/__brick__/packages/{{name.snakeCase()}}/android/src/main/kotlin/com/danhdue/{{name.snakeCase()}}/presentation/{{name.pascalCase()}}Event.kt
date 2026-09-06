/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

/*
 * coverage:ignore-file
 */

package com.danhdue.{{name.snakeCase()}}.presentation

sealed interface {{name.pascalCase()}}Event : BaseEvent {
    data class ShowToast(val message: String) : {{name.pascalCase()}}Event
}
