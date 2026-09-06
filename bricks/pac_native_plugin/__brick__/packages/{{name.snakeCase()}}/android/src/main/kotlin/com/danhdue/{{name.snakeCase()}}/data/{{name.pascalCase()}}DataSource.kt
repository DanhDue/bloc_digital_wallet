package com.danhdue.{{name.snakeCase()}}.data

import com.danhdue.{{name.snakeCase()}}.domain.{{name.pascalCase()}}Repository

class {{name.pascalCase()}}DataSource : {{name.pascalCase()}}Repository {
    override suspend fun getStatus(): Result<String> {
        return Result.success("Active")
    }
}
