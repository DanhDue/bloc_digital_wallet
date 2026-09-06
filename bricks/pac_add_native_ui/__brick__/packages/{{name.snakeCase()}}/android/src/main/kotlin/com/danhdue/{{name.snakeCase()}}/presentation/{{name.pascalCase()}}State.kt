/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

/*
 * coverage:ignore-file
 */

package com.danhdue.{{name.snakeCase()}}.presentation

data class {{name.pascalCase()}}State(
    val isLoading: Boolean = false,
    val title: String = "{{name.pascalCase()}} Native UI",
    val error: String? = null
) : BaseState
