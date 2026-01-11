// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'mvi_base.dart';

/// Base BLoC for MVI pattern
/// Follows Android MVI architecture: Action → State transformation with Events
///
/// Key principles from Android architecture:
/// - Single entry point: onAction(action)
/// - State managed with StateFlow pattern
/// - Events managed with Channel (one-shot)
/// - Unidirectional data flow: View → ViewModel → Domain → Data → View
abstract class MviBloc<
  Action extends BaseAction,
  State extends BaseState,
  Event extends BaseEvent
>
    extends Bloc<Action, State> {
  MviBloc(super.initialState) {
    _eventController = StreamController<Event>.broadcast();
  }

  late final StreamController<Event> _eventController;

  /// Stream of events (one-time side effects like Navigation, Toast, Dialog)
  /// Similar to Android's Channel of Event
  Stream<Event> get events => _eventController.stream;

  /// Emit an event (side effect)
  /// Use for one-time actions: navigation, snackbars, dialogs
  void emitEvent(Event event) {
    if (!_eventController.isClosed) {
      _eventController.add(event);
    }
  }

  /// Single entry point for all user actions
  /// This is the ONLY method View should call
  /// Similar to Android's: fun onAction(action: Action)
  void onAction(Action action);

  /// Helper: Handle actions with concurrent transformer
  void handleAction<T extends Action>(
    EventTransformer<T>? transformer,
    EventHandler<T, State> handler,
  ) {
    on<T>(handler, transformer: transformer ?? concurrent());
  }

  /// Helper: Handle actions sequentially
  void handleActionSequential<T extends Action>(
    EventHandler<T, State> handler,
  ) {
    on<T>(handler, transformer: sequential());
  }

  /// Helper: Handle actions with restart on new
  void handleActionRestartable<T extends Action>(
    EventHandler<T, State> handler,
  ) {
    on<T>(handler, transformer: restartable());
  }

  /// Helper: Handle actions with drop while processing
  void handleActionDroppable<T extends Action>(EventHandler<T, State> handler) {
    on<T>(handler, transformer: droppable());
  }

  @override
  Future<void> close() {
    _eventController.close();
    return super.close();
  }
}
