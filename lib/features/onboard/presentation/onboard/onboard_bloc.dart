// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when adding action handlers
// import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/architecture/architecture.dart';
import 'onboard_action.dart';
import 'onboard_state.dart';
import 'onboard_event.dart';

/// ============================================================================
/// Onboard BLoC
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
/// class OnboardBloc extends MviBloc<...> {
///   final GetOnboardUseCase _getOnboardUseCase;
///
///   OnboardBloc(this._getOnboardUseCase)
///       : super(const OnboardInitial()) {
///     handleActionDroppable<LoadOnboardAction>(_onLoad);
///   }
///
///   Future<void> _onLoad(
///     LoadOnboardAction action,
///     Emitter<OnboardState> emit,
///   ) async {
///     emit(const OnboardLoading());
///     final result = await _getOnboardUseCase();
///     result.fold(
///       (failure) => emit(OnboardError(failure.message)),
///       (data) => emit(OnboardSuccess(data)),
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
class OnboardBloc extends MviBloc<OnboardAction, OnboardState, OnboardEvent> {
  OnboardBloc() : super(const OnboardInitial()) {
    // TODO: Register action handlers here
    // handleActionDroppable<InitOnboardAction>(_onInit);
  }

  @override
  void onAction(OnboardAction action) {
    add(action);
  }

  // TODO: Implement action handlers
  // Future<void> _onInit(
  //   InitOnboardAction action,
  //   Emitter<OnboardState> emit,
  // ) async {
  //   // Handle initialization
  // }
}
