package com.danhdue.{{name.snakeCase()}}.presentation

import android.content.Context
import android.view.View
import androidx.compose.ui.platform.ComposeView
import io.flutter.plugin.platform.PlatformView

class {{name.pascalCase()}}PlatformView(
    context: Context,
    viewId: Int,
    args: Any?,
    viewModel: {{name.pascalCase()}}ViewModel
) : PlatformView {
    private val composeView = ComposeView(context).apply {
        setContent {
            {{name.pascalCase()}}Screen(viewModel = viewModel)
        }
    }

    override fun getView(): View = composeView

    override fun dispose() {}
}
