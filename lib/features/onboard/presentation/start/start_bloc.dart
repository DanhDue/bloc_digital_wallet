// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when adding action handlers
// import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/architecture/architecture.dart';
import 'start_action.dart';
import 'start_state.dart';
import 'start_event.dart';

/// ============================================================================
/// Start BLoC
/// ============================================================================
/// The BLoC processes Actions and emits States/Events.
///
/// HOW TO EXTEND:
/// 1. Add use case dependencies via constructor injection
/// 2. Register action handlers in constructor using handleAction methods
/// 3. Implement handler methods that emit new states/events
///
/// EXAMPLE - Adding use case and handler:
/// ```dart
/// @injectable
/// class StartBloc extends MviBloc<...> {
///   final GetStartUseCase _getStartUseCase;
///
///   StartBloc(this._getStartUseCase)
///       : super(const StartInitial()) {
///     handleActionDroppable<LoadStartAction>(_onLoad);
///   }
///
///   Future<void> _onLoad(
///     LoadStartAction action,
///     Emitter<StartState> emit,
///   ) async {
///     emit(const StartLoading());
///     final result = await _getStartUseCase();
///     result.fold(
///       (failure) => emit(StartError(failure.message)),
///       (data) => emit(StartSuccess(data)),
///     );
///   }
/// }
/// ```
///
/// ACTION HANDLER TYPES:
/// - handleActionDroppable: Drops new actions while processing (default)
/// - handleActionSequential: Queues actions, processes one at a time
/// - handleActionConcurrent: Processes actions concurrently
/// ============================================================================

@injectable
class StartBloc extends MviBloc<StartAction, StartState, StartEvent> {
  StartBloc() : super(const StartInitial()) {
    // TODO: Register action handlers here
    // handleActionDroppable<LoadStartAction>(_onLoad);
  }

  @override
  void onAction(StartAction action) {
    add(action);
  }

  // TODO: Implement action handlers
  // Future<void> _onLoad(
  //   LoadStartAction action,
  //   Emitter<StartState> emit,
  // ) async {
  //   // Handle loading
  // }
}
