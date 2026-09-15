/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

package com.danhdue.{{name.snakeCase()}}.di

import com.danhdue.{{name.snakeCase()}}.domain.repository.{{name.pascalCase()}}Repository
import com.danhdue.{{name.snakeCase()}}.domain.usecase.GetDataUseCase
import com.danhdue.{{name.snakeCase()}}.domain.usecase.SyncDataUseCase
{{#has_ui}}
import com.danhdue.{{name.snakeCase()}}.presentation.{{name.pascalCase()}}ViewModel
{{/has_ui}}
import dagger.Component
import javax.inject.Singleton

@Singleton
@Component(modules = [{{name.pascalCase()}}Module::class])
interface {{name.pascalCase()}}Component {
    fun get{{name.pascalCase()}}Repository(): {{name.pascalCase()}}Repository
    fun getGetDataUseCase(): GetDataUseCase
    fun getSyncDataUseCase(): SyncDataUseCase
{{#has_ui}}
    fun get{{name.pascalCase()}}ViewModel(): {{name.pascalCase()}}ViewModel
{{/has_ui}}

    @Component.Builder
    interface Builder {
        fun build(): {{name.pascalCase()}}Component
    }
}
