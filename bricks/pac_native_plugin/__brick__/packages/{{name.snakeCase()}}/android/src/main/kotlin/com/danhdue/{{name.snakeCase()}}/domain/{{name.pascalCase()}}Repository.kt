package com.danhdue.{{name.snakeCase()}}.domain

interface {{name.pascalCase()}}Repository {
    suspend fun getStatus(): Result<String>
}
