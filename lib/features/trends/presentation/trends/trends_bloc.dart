// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when adding action handlers
// import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/architecture/architecture.dart';
import 'trends_action.dart';
import 'trends_state.dart';
import 'trends_event.dart';

/// ============================================================================
/// Trends BLoC
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
/// class TrendsBloc extends MviBloc<...> {
///   final GetTrendsUseCase _getTrendsUseCase;
///
///   TrendsBloc(this._getTrendsUseCase)
///       : super(const TrendsInitial()) {
///     handleActionDroppable<LoadTrendsAction>(_onLoad);
///   }
///
///   Future<void> _onLoad(
///     LoadTrendsAction action,
///     Emitter<TrendsState> emit,
///   ) async {
///     emit(const TrendsLoading());
///     final result = await _getTrendsUseCase();
///     result.fold(
///       (failure) => emit(TrendsError(failure.message)),
///       (data) => emit(TrendsSuccess(data)),
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
class TrendsBloc extends MviBloc<TrendsAction, TrendsState, TrendsEvent> {
  TrendsBloc() : super(const TrendsInitial()) {
    // TODO: Register action handlers here
    // handleActionDroppable<InitTrendsAction>(_onInit);
  }

  @override
  void onAction(TrendsAction action) {
    add(action);
  }

  // TODO: Implement action handlers
  // Future<void> _onInit(
  //   InitTrendsAction action,
  //   Emitter<TrendsState> emit,
  // ) async {
  //   // Handle initialization
  // }
}
