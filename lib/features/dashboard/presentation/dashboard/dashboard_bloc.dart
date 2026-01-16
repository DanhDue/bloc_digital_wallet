// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
import '../../../../core/architecture/architecture.dart';
import 'dashboard_action.dart';
import 'dashboard_state.dart';
import 'dashboard_event.dart';

/// ============================================================================
/// Dashboard BLoC
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
/// class DashboardBloc extends MviBloc<...> {
///   final GetDashboardUseCase _getDashboardUseCase;
///
///   DashboardBloc(this._getDashboardUseCase)
///       : super(const DashboardInitial()) {
///     handleActionDroppable<LoadDashboardAction>(_onLoad);
///   }
///
///   Future<void> _onLoad(
///     LoadDashboardAction action,
///     Emitter<DashboardState> emit,
///   ) async {
///     emit(const DashboardLoading());
///     final result = await _getDashboardUseCase();
///     result.fold(
///       (failure) => emit(DashboardError(failure.message)),
///       (data) => emit(DashboardSuccess(data)),
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
class DashboardBloc extends MviBloc<DashboardAction, DashboardState, DashboardEvent> {
  DashboardBloc() : super(const DashboardInitial()) {
    // TODO: Register action handlers here
    // handleActionDroppable<InitDashboardAction>(_onInit);
  }

  @override
  void onAction(DashboardAction action) {
    add(action);
  }

  // TODO: Implement action handlers
  // Future<void> _onInit(
  //   InitDashboardAction action,
  //   Emitter<DashboardState> emit,
  // ) async {
  //   // Handle initialization
  // }
}
