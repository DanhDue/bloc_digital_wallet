/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

/*
 * coverage:ignore-file
 */

package com.danhdue.{{name.snakeCase()}}

import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec

interface {{name.pascalCase()}}HostApi {
    fun getPlatformVersion(): String

    companion object {
        val codec: StandardMessageCodec = StandardMessageCodec.INSTANCE

        fun setUp(binaryMessenger: BinaryMessenger, api: {{name.pascalCase()}}HostApi?) {
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
                        reply.reply(listOf<Any?>(null, error.message, error.cause))
                    }
                }
            } else {
                channel.setMessageHandler(null)
            }
        }
    }
}
