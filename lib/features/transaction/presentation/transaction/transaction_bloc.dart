// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when adding action handlers
// import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/architecture/architecture.dart';
import 'transaction_action.dart';
import 'transaction_state.dart';
import 'transaction_event.dart';

/// ============================================================================
/// Transaction BLoC
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
/// class TransactionBloc extends MviBloc<...> {
///   final GetTransactionUseCase _getTransactionUseCase;
///
///   TransactionBloc(this._getTransactionUseCase)
///       : super(const TransactionInitial()) {
///     handleActionDroppable<LoadTransactionAction>(_onLoad);
///   }
///
///   Future<void> _onLoad(
///     LoadTransactionAction action,
///     Emitter<TransactionState> emit,
///   ) async {
///     emit(const TransactionLoading());
///     final result = await _getTransactionUseCase();
///     result.fold(
///       (failure) => emit(TransactionError(failure.message)),
///       (data) => emit(TransactionSuccess(data)),
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
class TransactionBloc extends MviBloc<TransactionAction, TransactionState, TransactionEvent> {
  TransactionBloc() : super(const TransactionInitial()) {
    // TODO: Register action handlers here
    // handleActionDroppable<InitTransactionAction>(_onInit);
  }

  @override
  void onAction(TransactionAction action) {
    add(action);
  }

  // TODO: Implement action handlers
  // Future<void> _onInit(
  //   InitTransactionAction action,
  //   Emitter<TransactionState> emit,
  // ) async {
  //   // Handle initialization
  // }
}
