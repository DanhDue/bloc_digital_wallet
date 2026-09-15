/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

/*
 * coverage:ignore-file
 */

package com.danhdue.{{name.snakeCase()}}.platform

import android.content.Context
import com.danhdue.{{name.snakeCase()}}.presentation.{{name.pascalCase()}}PlatformView
import com.danhdue.{{name.snakeCase()}}.presentation.{{name.pascalCase()}}ViewModel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class {{name.pascalCase()}}PlatformViewFactory(
    private val viewModelProvider: () -> {{name.pascalCase()}}ViewModel
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    constructor(viewModel: {{name.pascalCase()}}ViewModel) : this({ viewModel })

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return {{name.pascalCase()}}PlatformView(context, viewId, args, viewModelProvider())
    }
}
