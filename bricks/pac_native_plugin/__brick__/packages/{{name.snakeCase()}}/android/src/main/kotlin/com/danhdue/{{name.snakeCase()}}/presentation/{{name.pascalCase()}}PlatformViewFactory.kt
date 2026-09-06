package com.danhdue.{{name.snakeCase()}}.presentation

import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class {{name.pascalCase()}}PlatformViewFactory(
    private val viewModel: {{name.pascalCase()}}ViewModel
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return {{name.pascalCase()}}PlatformView(context, viewId, args, viewModel)
    }
}
