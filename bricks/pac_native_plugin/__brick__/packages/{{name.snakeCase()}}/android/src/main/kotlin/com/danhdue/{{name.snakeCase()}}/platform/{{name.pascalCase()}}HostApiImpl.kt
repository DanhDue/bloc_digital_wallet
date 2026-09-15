/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

package com.danhdue.{{name.snakeCase()}}.platform

import com.danhdue.{{name.snakeCase()}}.domain.usecase.GetDataUseCase
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import javax.inject.Inject

class {{name.pascalCase()}}HostApiImpl @Inject constructor(
    private val getDataUseCase: GetDataUseCase,
    private val coroutineScope: CoroutineScope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)
) : {{name.pascalCase()}}HostApi {

    override fun getPlatformVersion(): String {
        return "Android ${android.os.Build.VERSION.RELEASE}"
    }

    override fun getData(callback: (Result<Pigeon{{name.pascalCase()}}Data>) -> Unit) {
        coroutineScope.launch {
            try {
                val outcome = getDataUseCase.execute()
                if (outcome.isSuccess) {
                    val data = outcome.getOrNull()
                    val pigeonData = Pigeon{{name.pascalCase()}}Data(
                        id = data?.id.orEmpty(),
                        title = data?.title.orEmpty(),
                        timestamp = data?.timestamp ?: 0L
                    )
                    callback(Result.success(pigeonData))
                } else {
                    callback(Result.failure(outcome.exceptionOrNull() ?: RuntimeException("Unknown error")))
                }
            } catch (e: Throwable) {
                callback(Result.failure(e))
            }
        }
    }
}
