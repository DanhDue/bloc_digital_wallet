/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

package com.danhdue.{{name.snakeCase()}}.platform

import com.danhdue.{{name.snakeCase()}}.domain.model.{{name.pascalCase()}}Data
import com.danhdue.{{name.snakeCase()}}.domain.usecase.GetDataUseCase
import io.mockk.coEvery
import io.mockk.mockk
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.test.StandardTestDispatcher
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test

@OptIn(ExperimentalCoroutinesApi::class)
class {{name.pascalCase()}}HostApiImplTest {

    private val testDispatcher = StandardTestDispatcher()
    private val testScope = TestScope(testDispatcher)
    private val mockGetDataUseCase: GetDataUseCase = mockk()

    private lateinit var hostApi: {{name.pascalCase()}}HostApiImpl

    @Before
    fun setUp() {
        hostApi = {{name.pascalCase()}}HostApiImpl(
            getDataUseCase = mockGetDataUseCase,
            coroutineScope = testScope
        )
    }

    @Test
    fun `getPlatformVersion returns non-empty Android platform version`() {
        val version = hostApi.getPlatformVersion()
        assertNotNull(version)
        assertTrue(version.startsWith("Android"))
    }

    @Test
    fun `getData returns success with typed Pigeon{{name.pascalCase()}}Data`() = runTest(testDispatcher) {
        val domainData = {{name.pascalCase()}}Data(id = "123", title = "Pigeon Title", timestamp = 12345L)
        coEvery { mockGetDataUseCase.execute() } returns Result.success(domainData)

        var callbackResult: Result<Pigeon{{name.pascalCase()}}Data>? = null
        hostApi.getData { result ->
            callbackResult = result
        }

        advanceUntilIdle()

        assertNotNull(callbackResult)
        assertTrue(callbackResult!!.isSuccess)
        val data = callbackResult!!.getOrNull()
        assertEquals("123", data?.id)
        assertEquals("Pigeon Title", data?.title)
        assertEquals(12345L, data?.timestamp)
    }

    @Test
    fun `getData propagates exception as Result failure`() = runTest(testDispatcher) {
        coEvery { mockGetDataUseCase.execute() } returns Result.failure(RuntimeException("Pigeon IPC Failure"))

        var callbackResult: Result<Pigeon{{name.pascalCase()}}Data>? = null
        hostApi.getData { result ->
            callbackResult = result
        }

        advanceUntilIdle()

        assertNotNull(callbackResult)
        assertTrue(callbackResult!!.isFailure)
        assertEquals("Pigeon IPC Failure", callbackResult!!.exceptionOrNull()?.message)
    }
}
