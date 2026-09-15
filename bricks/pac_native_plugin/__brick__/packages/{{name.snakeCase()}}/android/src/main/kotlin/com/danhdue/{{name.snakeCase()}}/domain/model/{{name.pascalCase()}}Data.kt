/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

package com.danhdue.{{name.snakeCase()}}.domain.model

data class {{name.pascalCase()}}Data(
    val id: String,
    val title: String,
    val timestamp: Long = System.currentTimeMillis()
)
