/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

/*
 * coverage:ignore-file
 */

package com.danhdue.{{name.snakeCase()}}

import com.danhdue.{{name.snakeCase()}}.di.{{name.pascalCase()}}ComponentProvider
{{#has_ui}}
import com.danhdue.{{name.snakeCase()}}.platform.{{name.pascalCase()}}PlatformViewFactory
{{/has_ui}}
{{^has_ui}}
import com.danhdue.{{name.snakeCase()}}.platform.{{name.pascalCase()}}HostApi
import com.danhdue.{{name.snakeCase()}}.platform.{{name.pascalCase()}}HostApiImpl
{{/has_ui}}
import io.flutter.embedding.engine.plugins.FlutterPlugin

class {{name.pascalCase()}}Plugin : FlutterPlugin {
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val component = {{name.pascalCase()}}ComponentProvider.get(flutterPluginBinding.applicationContext)

{{#has_ui}}
        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            VIEW_TYPE,
            {{name.pascalCase()}}PlatformViewFactory {
                component.get{{name.pascalCase()}}ViewModel()
            }
        )
{{/has_ui}}
{{^has_ui}}
        {{name.pascalCase()}}HostApi.setUp(
            flutterPluginBinding.binaryMessenger,
            {{name.pascalCase()}}HostApiImpl(component.getGetDataUseCase())
        )
{{/has_ui}}
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
{{^has_ui}}
        {{name.pascalCase()}}HostApi.setUp(binding.binaryMessenger, null)
{{/has_ui}}
    }

    companion object {
        const val VIEW_TYPE = "com.danhdue.{{name.snakeCase()}}/native_view"
    }
}
