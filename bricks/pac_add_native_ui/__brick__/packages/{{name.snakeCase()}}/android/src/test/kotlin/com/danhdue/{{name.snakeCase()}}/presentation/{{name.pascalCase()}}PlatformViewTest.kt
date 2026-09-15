/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

package com.danhdue.{{name.snakeCase()}}.presentation

import android.content.Context
import com.danhdue.{{name.snakeCase()}}.platform.{{name.pascalCase()}}PlatformViewFactory
import io.mockk.mockk
import org.junit.Assert.assertNotNull
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34])
class {{name.pascalCase()}}PlatformViewTest {

    private lateinit var mockContext: Context
    private lateinit var mockViewModel: {{name.pascalCase()}}ViewModel

    @Before
    fun setUp() {
        mockContext = RuntimeEnvironment.getApplication()
        mockViewModel = mockk(relaxed = true)
    }

    @Test
    fun `PlatformViewFactory creates PlatformView successfully`() {
        val factory = {{name.pascalCase()}}PlatformViewFactory(mockViewModel)
        val platformView = factory.create(mockContext, 1, null)

        assertNotNull(platformView)
        assertNotNull(platformView.view)
    }

    @Test
    fun `PlatformView disposes cleanly without exceptions`() {
        val platformView = {{name.pascalCase()}}PlatformView(mockContext, 1, null, mockViewModel)
        platformView.dispose()
    }
}
