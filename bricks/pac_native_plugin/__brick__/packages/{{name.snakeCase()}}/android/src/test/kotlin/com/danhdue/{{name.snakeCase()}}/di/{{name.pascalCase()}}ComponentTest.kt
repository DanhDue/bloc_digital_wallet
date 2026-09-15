/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

package com.danhdue.{{name.snakeCase()}}.di

import android.content.Context
import io.mockk.every
import io.mockk.mockk
import java.util.concurrent.CountDownLatch
import java.util.concurrent.Executors
import java.util.concurrent.atomic.AtomicReference
import kotlinx.coroutines.runBlocking
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNotSame
import org.junit.Assert.assertSame
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test

class {{name.pascalCase()}}ComponentTest {

    private lateinit var mockContext: Context

    @Before
    fun setUp() {
        {{name.pascalCase()}}ComponentProvider.reset()
        mockContext = mockk(relaxed = true)
        every { mockContext.applicationContext } returns mockContext
    }

    @After
    fun tearDown() {
        {{name.pascalCase()}}ComponentProvider.reset()
    }

    @Test
    fun `ComponentProvider returns non-null component with working use cases`() = runBlocking {
        val component = {{name.pascalCase()}}ComponentProvider.get(mockContext)
        assertNotNull(component)

        val repo = component.get{{name.pascalCase()}}Repository()
        assertNotNull(repo)

        val getDataUseCase = component.getGetDataUseCase()
        assertNotNull(getDataUseCase)

        val dataResult = getDataUseCase.execute()
        assertTrue(dataResult.isSuccess)
        assertEquals("sample-data-1", dataResult.getOrNull()?.id)

        val syncUseCase = component.getSyncDataUseCase()
        assertNotNull(syncUseCase)
        val syncResult = syncUseCase.execute()
        assertTrue(syncResult.isSuccess)
        assertEquals(true, syncResult.getOrNull())
    }

    @Test
    fun `ComponentProvider returns same singleton instance on repeated calls`() {
        val first = {{name.pascalCase()}}ComponentProvider.get(mockContext)
        val second = {{name.pascalCase()}}ComponentProvider.get(mockContext)
        assertSame(first, second)
    }

    @Test
    fun `ComponentProvider reset creates new instance`() {
        val first = {{name.pascalCase()}}ComponentProvider.get(mockContext)
        {{name.pascalCase()}}ComponentProvider.reset()
        val second = {{name.pascalCase()}}ComponentProvider.get(mockContext)
        assertNotSame(first, second)
    }

    @Test
    fun `ComponentProvider is thread-safe under concurrent access`() {
        val threadCount = 10
        val latch = CountDownLatch(threadCount)
        val executor = Executors.newFixedThreadPool(threadCount)
        val results = mutableListOf<{{name.pascalCase()}}Component>()
        val errorRef = AtomicReference<Throwable?>(null)

        repeat(threadCount) {
            executor.submit {
                try {
                    val comp = {{name.pascalCase()}}ComponentProvider.get(mockContext)
                    synchronized(results) { results.add(comp) }
                } catch (t: Throwable) {
                    errorRef.set(t)
                } finally {
                    latch.countDown()
                }
            }
        }

        latch.await()
        executor.shutdown()

        assertTrue("Error during concurrent access: ${errorRef.get()}", errorRef.get() == null)
        assertEquals(threadCount, results.size)
        val first = results.first()
        results.forEach { assertSame(first, it) }
    }

    @Test
    fun `ComponentProvider handles null applicationContext gracefully`() {
        val fallbackContext: Context = mockk(relaxed = true)
        every { fallbackContext.applicationContext } returns null

        val component = {{name.pascalCase()}}ComponentProvider.get(fallbackContext)
        assertNotNull(component)
    }
}
