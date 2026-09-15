/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

package com.danhdue.{{name.snakeCase()}}.di

import android.content.Context
import com.danhdue.{{name.snakeCase()}}.data.repository.{{name.pascalCase()}}RepositoryImpl
import com.danhdue.{{name.snakeCase()}}.domain.repository.{{name.pascalCase()}}Repository
import dagger.Binds
import dagger.Module
import dagger.Provides
import javax.inject.Singleton

@Module
abstract class {{name.pascalCase()}}Module {

    @Binds
    @Singleton
    abstract fun bind{{name.pascalCase()}}Repository(
        impl: {{name.pascalCase()}}RepositoryImpl
    ): {{name.pascalCase()}}Repository

    companion object {
        @Volatile
        private var appContext: Context? = null

        fun setContext(context: Context) {
            appContext = context.applicationContext ?: context
        }

        @Provides
        @Singleton
        fun provideContext(): Context {
            return appContext ?: throw IllegalStateException("Context not initialized in {{name.pascalCase()}}Module")
        }
    }
}
