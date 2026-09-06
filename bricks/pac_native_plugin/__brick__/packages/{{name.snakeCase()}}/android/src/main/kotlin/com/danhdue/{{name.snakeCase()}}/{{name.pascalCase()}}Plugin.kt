/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

/*
 * coverage:ignore-file
 */

package com.danhdue.{{name.snakeCase()}}

import io.flutter.embedding.engine.plugins.FlutterPlugin
{{#has_ui}}
import com.danhdue.{{name.snakeCase()}}.presentation.{{name.pascalCase()}}PlatformViewFactory
import com.danhdue.{{name.snakeCase()}}.presentation.{{name.pascalCase()}}ViewModel
{{/has_ui}}

class {{name.pascalCase()}}Plugin : FlutterPlugin{{^has_ui}}, {{name.pascalCase()}}HostApi{{/has_ui}} {
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
{{#has_ui}}
        val viewModel = {{name.pascalCase()}}ViewModel()
        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            "com.danhdue.{{name.snakeCase()}}/native_view",
            {{name.pascalCase()}}PlatformViewFactory(viewModel)
        )
{{/has_ui}}
{{^has_ui}}
        {{name.pascalCase()}}HostApi.setUp(flutterPluginBinding.binaryMessenger, this)
{{/has_ui}}
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
{{^has_ui}}
        {{name.pascalCase()}}HostApi.setUp(binding.binaryMessenger, null)
{{/has_ui}}
    }
{{^has_ui}}

    override fun getPlatformVersion(): String {
        return "Android ${android.os.Build.VERSION.RELEASE}"
    }
{{/has_ui}}
}
