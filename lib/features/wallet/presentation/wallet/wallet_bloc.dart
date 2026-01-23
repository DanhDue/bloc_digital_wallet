// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when adding action handlers
// import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/architecture/architecture.dart';
import 'wallet_action.dart';
import 'wallet_state.dart';
import 'wallet_event.dart';

/// ============================================================================
/// Wallet BLoC
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
/// class WalletBloc extends MviBloc<...> {
///   final GetWalletUseCase _getWalletUseCase;
///
///   WalletBloc(this._getWalletUseCase)
///       : super(const WalletInitial()) {
///     handleActionDroppable<LoadWalletAction>(_onLoad);
///   }
///
///   Future<void> _onLoad(
///     LoadWalletAction action,
///     Emitter<WalletState> emit,
///   ) async {
///     emit(const WalletLoading());
///     final result = await _getWalletUseCase();
///     result.fold(
///       (failure) => emit(WalletError(failure.message)),
///       (data) => emit(WalletSuccess(data)),
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
class WalletBloc extends MviBloc<WalletAction, WalletState, WalletEvent> {
  WalletBloc() : super(const WalletInitial()) {
    // TODO: Register action handlers here
    // handleActionDroppable<InitWalletAction>(_onInit);
  }

  // TODO: Implement action handlers
  // Future<void> _onInit(
  //   InitWalletAction action,
  //   Emitter<WalletState> emit,
  // ) async {
  //   // Handle initialization
  // }
}
