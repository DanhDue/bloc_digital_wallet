/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

package com.danhdue.{{name.snakeCase()}}.data.worker

import android.content.Context
import androidx.work.ListenableWorker
import androidx.work.WorkerParameters
import com.danhdue.{{name.snakeCase()}}.di.{{name.pascalCase()}}Component
import com.danhdue.{{name.snakeCase()}}.di.{{name.pascalCase()}}ComponentProvider
import com.danhdue.{{name.snakeCase()}}.domain.usecase.SyncDataUseCase
import io.mockk.coEvery
import io.mockk.every
import io.mockk.mockk
import kotlinx.coroutines.runBlocking
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Before
import org.junit.Test

class {{name.pascalCase()}}SyncWorkerTest {

    private lateinit var mockContext: Context
    private lateinit var mockWorkerParams: WorkerParameters
    private lateinit var mockComponent: {{name.pascalCase()}}Component
    private lateinit var mockSyncUseCase: SyncDataUseCase

    @Before
    fun setUp() {
        {{name.pascalCase()}}ComponentProvider.reset()
        mockContext = mockk(relaxed = true)
        mockWorkerParams = mockk(relaxed = true)
        mockComponent = mockk(relaxed = true)
        mockSyncUseCase = mockk(relaxed = true)

        every { mockContext.applicationContext } returns mockContext
    }

    @After
    fun tearDown() {
        {{name.pascalCase()}}ComponentProvider.reset()
    }

    @Test
    fun `SyncWorker returns success when sync succeeds`() = runBlocking {
        every { mockComponent.getSyncDataUseCase() } returns mockSyncUseCase
        coEvery { mockSyncUseCase.execute() } returns Result.success(true)
        {{name.pascalCase()}}ComponentProvider.setComponent(mockComponent)

        val worker = {{name.pascalCase()}}SyncWorker(mockContext, mockWorkerParams)
        val result = worker.doWork()

        assertEquals(ListenableWorker.Result.success(), result)
    }

    @Test
    fun `SyncWorker returns retry when sync fails`() = runBlocking {
        every { mockComponent.getSyncDataUseCase() } returns mockSyncUseCase
        coEvery { mockSyncUseCase.execute() } returns Result.failure(RuntimeException("Network timeout"))
        {{name.pascalCase()}}ComponentProvider.setComponent(mockComponent)

        val worker = {{name.pascalCase()}}SyncWorker(mockContext, mockWorkerParams)
        val result = worker.doWork()

        assertEquals(ListenableWorker.Result.retry(), result)
    }

    @Test
    fun `SyncWorker returns retry when sync throws exception`() = runBlocking {
        every { mockComponent.getSyncDataUseCase() } returns mockSyncUseCase
        coEvery { mockSyncUseCase.execute() } throws RuntimeException("Unexpected error")
        {{name.pascalCase()}}ComponentProvider.setComponent(mockComponent)

        val worker = {{name.pascalCase()}}SyncWorker(mockContext, mockWorkerParams)
        val result = worker.doWork()

        assertEquals(ListenableWorker.Result.retry(), result)
    }
}
