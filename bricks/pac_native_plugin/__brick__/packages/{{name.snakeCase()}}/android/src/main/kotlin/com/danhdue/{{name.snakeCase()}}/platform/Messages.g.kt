/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

/*
 * coverage:ignore-file
 */

package com.danhdue.{{name.snakeCase()}}.platform

import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec

data class Pigeon{{name.pascalCase()}}Data(
    val id: String = "",
    val title: String = "",
    val timestamp: Long = 0L
) {
    companion object {
        fun fromList(list: List<Any?>): Pigeon{{name.pascalCase()}}Data {
            val id = list.getOrNull(0) as? String ?: ""
            val title = list.getOrNull(1) as? String ?: ""
            val timestamp = (list.getOrNull(2) as? Number)?.toLong() ?: 0L
            return Pigeon{{name.pascalCase()}}Data(id = id, title = title, timestamp = timestamp)
        }
    }

    fun toList(): List<Any?> {
        return listOf(id, title, timestamp)
    }
}

interface {{name.pascalCase()}}HostApi {
    fun getPlatformVersion(): String
    fun getData(callback: (Result<Pigeon{{name.pascalCase()}}Data>) -> Unit)

    companion object {
        val codec: StandardMessageCodec = StandardMessageCodec.INSTANCE

        fun setUp(binaryMessenger: BinaryMessenger, api: {{name.pascalCase()}}HostApi?) {
            run {
                val channel = BasicMessageChannel<Any?>(
                    binaryMessenger,
                    "dev.flutter.pigeon.{{name.snakeCase()}}.{{name.pascalCase()}}HostApi.getPlatformVersion",
                    codec
                )
                if (api != null) {
                    channel.setMessageHandler { _, reply ->
                        try {
                            reply.reply(listOf(api.getPlatformVersion()))
                        } catch (error: Throwable) {
                            reply.reply(listOf<Any?>(null, error.message, error.cause?.toString()))
                        }
                    }
                } else {
                    channel.setMessageHandler(null)
                }
            }

            run {
                val channel = BasicMessageChannel<Any?>(
                    binaryMessenger,
                    "dev.flutter.pigeon.{{name.snakeCase()}}.{{name.pascalCase()}}HostApi.getData",
                    codec
                )
                if (api != null) {
                    channel.setMessageHandler { _, reply ->
                        api.getData { result ->
                            if (result.isSuccess) {
                                val data = result.getOrNull() ?: Pigeon{{name.pascalCase()}}Data()
                                reply.reply(listOf(data.toList()))
                            } else {
                                val error = result.exceptionOrNull()
                                reply.reply(listOf<Any?>(null, error?.message ?: "Unknown error", null))
                            }
                        }
                    }
                } else {
                    channel.setMessageHandler(null)
                }
            }
        }
    }
}
