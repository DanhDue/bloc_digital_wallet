// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when adding action handlers
// import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/architecture/architecture.dart';
import 'network_selection_action.dart';
import 'network_selection_state.dart';
import 'network_selection_event.dart';

/// ============================================================================
/// NetworkSelection BLoC
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
/// class NetworkSelectionBloc extends MviBloc<...> {
///   final GetNetworkSelectionUseCase _getNetworkSelectionUseCase;
///
///   NetworkSelectionBloc(this._getNetworkSelectionUseCase)
///       : super(const NetworkSelectionInitial()) {
///     handleActionDroppable<LoadNetworkSelectionAction>(_onLoad);
///   }
///
///   Future<void> _onLoad(
///     LoadNetworkSelectionAction action,
///     Emitter<NetworkSelectionState> emit,
///   ) async {
///     emit(const NetworkSelectionLoading());
///     final result = await _getNetworkSelectionUseCase();
///     result.fold(
///       (failure) => emit(NetworkSelectionError(failure.message)),
///       (data) => emit(NetworkSelectionSuccess(data)),
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
class NetworkSelectionBloc
    extends MviBloc<NetworkSelectionAction, NetworkSelectionState, NetworkSelectionEvent> {
  NetworkSelectionBloc() : super(const NetworkSelectionInitial()) {
    // TODO: Register action handlers here
    // handleActionDroppable<LoadNetworkSelectionAction>(_onLoad);
  }

  // TODO: Implement action handlers
  // Future<void> _onLoad(
  //   LoadNetworkSelectionAction action,
  //   Emitter<NetworkSelectionState> emit,
  // ) async {
  //   // Handle loading
  // }
}
