/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

package com.danhdue.{{name.snakeCase()}}.domain.repository

import com.danhdue.{{name.snakeCase()}}.domain.model.{{name.pascalCase()}}Data

interface {{name.pascalCase()}}Repository {
    suspend fun getData(): Result<{{name.pascalCase()}}Data>
    suspend fun syncData(): Result<Boolean>
}
