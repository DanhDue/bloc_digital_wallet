/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

package com.danhdue.{{name.snakeCase()}}.data.worker

import android.content.Context
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import com.danhdue.{{name.snakeCase()}}.di.{{name.pascalCase()}}ComponentProvider

class {{name.pascalCase()}}SyncWorker(
    appContext: Context,
    workerParams: WorkerParameters
) : CoroutineWorker(appContext, workerParams) {

    override suspend fun doWork(): Result {
        return try {
            val syncUseCase = {{name.pascalCase()}}ComponentProvider.get(applicationContext).getSyncDataUseCase()
            val outcome = syncUseCase.execute()
            if (outcome.isSuccess && outcome.getOrNull() == true) {
                Result.success()
            } else {
                Result.retry()
            }
        } catch (e: Exception) {
            Result.retry()
        }
    }
}
