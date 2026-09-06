/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

/*
 * coverage:ignore-file
 */

package com.danhdue.{{name.snakeCase()}}.domain

interface {{name.pascalCase()}}Repository {
    suspend fun getStatus(): Result<String>
}
