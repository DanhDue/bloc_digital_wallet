/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

/*
 * coverage:ignore-file
 */

package com.danhdue.{{name.snakeCase()}}.presentation

import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class {{name.pascalCase()}}PlatformViewFactory(
    private val viewModel: {{name.pascalCase()}}ViewModel = {{name.pascalCase()}}ViewModel()
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return {{name.pascalCase()}}PlatformView(context, viewModel)
    }
}
