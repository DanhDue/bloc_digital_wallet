// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when adding action handlers
// import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/architecture/architecture.dart';
import 'scanner_action.dart';
import 'scanner_state.dart';
import 'scanner_event.dart';

/// ============================================================================
/// Scanner BLoC
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
/// class ScannerBloc extends MviBloc<...> {
///   final GetScannerUseCase _getScannerUseCase;
///
///   ScannerBloc(this._getScannerUseCase)
///       : super(const ScannerInitial()) {
///     handleActionDroppable<LoadScannerAction>(_onLoad);
///   }
///
///   Future<void> _onLoad(
///     LoadScannerAction action,
///     Emitter<ScannerState> emit,
///   ) async {
///     emit(const ScannerLoading());
///     final result = await _getScannerUseCase();
///     result.fold(
///       (failure) => emit(ScannerError(failure.message)),
///       (data) => emit(ScannerSuccess(data)),
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
class ScannerBloc extends MviBloc<ScannerAction, ScannerState, ScannerEvent> {
  ScannerBloc() : super(const ScannerInitial()) {
    // TODO: Register action handlers here
    // handleActionDroppable<InitScannerAction>(_onInit);
  }

  @override
  void onAction(ScannerAction action) {
    add(action);
  }

  // TODO: Implement action handlers
  // Future<void> _onInit(
  //   InitScannerAction action,
  //   Emitter<ScannerState> emit,
  // ) async {
  //   // Handle initialization
  // }
}
