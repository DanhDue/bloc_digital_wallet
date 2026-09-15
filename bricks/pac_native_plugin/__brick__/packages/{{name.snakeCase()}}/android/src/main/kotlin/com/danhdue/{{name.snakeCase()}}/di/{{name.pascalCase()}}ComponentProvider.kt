/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

package com.danhdue.{{name.snakeCase()}}.di

import android.content.Context
import androidx.annotation.VisibleForTesting

object {{name.pascalCase()}}ComponentProvider {
    @Volatile
    private var instance: {{name.pascalCase()}}Component? = null

    fun get(context: Context): {{name.pascalCase()}}Component =
        instance ?: synchronized(this) {
            instance ?: run {
                {{name.pascalCase()}}Module.setContext(context)
                Dagger{{name.pascalCase()}}Component.builder()
                    .build()
                    .also { instance = it }
            }
        }

    @VisibleForTesting
    fun setComponent(component: {{name.pascalCase()}}Component) {
        instance = component
    }

    @VisibleForTesting
    fun reset() {
        instance = null
    }
}
