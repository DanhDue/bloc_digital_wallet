/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

package com.danhdue.{{name.snakeCase()}}.domain.usecase

import com.danhdue.{{name.snakeCase()}}.domain.repository.{{name.pascalCase()}}Repository
import javax.inject.Inject

class SyncDataUseCase @Inject constructor(
    private val repository: {{name.pascalCase()}}Repository
) {
    suspend fun execute(): Result<Boolean> = repository.syncData()
}
