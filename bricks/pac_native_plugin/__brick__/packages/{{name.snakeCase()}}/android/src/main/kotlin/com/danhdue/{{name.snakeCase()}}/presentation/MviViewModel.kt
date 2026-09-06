/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

/*
 * coverage:ignore-file
 */

package com.danhdue.{{name.snakeCase()}}.presentation

import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.receiveAsFlow

interface BaseAction
interface BaseState
interface BaseEvent

abstract class MviViewModel<A : BaseAction, S : BaseState, E : BaseEvent>(initialState: S) {
    private val _uiState = MutableStateFlow(initialState)
    val uiState: StateFlow<S> = _uiState.asStateFlow()

    private val _eventChannel = Channel<E>(Channel.BUFFERED)
    val eventFlow = _eventChannel.receiveAsFlow()

    protected fun setState(reducer: S.() -> S) {
        _uiState.value = _uiState.value.reducer()
    }

    protected suspend fun sendEvent(event: E) {
        _eventChannel.send(event)
    }

    abstract fun onAction(action: A)
}
