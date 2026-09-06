package com.danhdue.{{name.snakeCase()}}.presentation

import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.receiveAsFlow

interface BaseAction
interface BaseState
interface BaseEvent

abstract class MviViewModel<A : BaseAction, S : BaseState, E : BaseEvent>(
    initialState: S
) {
    private val _state = MutableStateFlow(initialState)
    val state: StateFlow<S> = _state.asStateFlow()

    private val _event = Channel<E>(Channel.BUFFERED)
    val event = _event.receiveAsFlow()

    protected fun setState(update: S.() -> S) {
        _state.value = _state.value.update()
    }

    protected suspend fun sendEvent(event: E) {
        _event.send(event)
    }

    abstract fun onAction(action: A)
}
