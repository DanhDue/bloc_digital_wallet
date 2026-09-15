/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

package com.danhdue.{{name.snakeCase()}}.data.repository

import com.danhdue.{{name.snakeCase()}}.domain.model.{{name.pascalCase()}}Data
import com.danhdue.{{name.snakeCase()}}.domain.repository.{{name.pascalCase()}}Repository
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class {{name.pascalCase()}}RepositoryImpl @Inject constructor() : {{name.pascalCase()}}Repository {
    override suspend fun getData(): Result<{{name.pascalCase()}}Data> {
        return Result.success(
            {{name.pascalCase()}}Data(
                id = "sample-data-1",
                title = "Native Android {{name.pascalCase()}} Payload"
            )
        )
    }

    override suspend fun syncData(): Result<Boolean> {
        return Result.success(true)
    }
}
