// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when adding action handlers
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_wallet_usecase.dart';
import '../../../../core/architecture/architecture.dart';
import 'wallet_list_action.dart';
import 'wallet_list_state.dart';
import 'wallet_list_event.dart';

/// ============================================================================
/// WalletList BLoC
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
/// class WalletListBloc extends MviBloc<...> {
///   final GetWalletListUseCase _getWalletListUseCase;
///
///   WalletListBloc(this._getWalletListUseCase)
///       : super(const WalletListInitial()) {
///     handleActionDroppable<LoadWalletListAction>(_onLoad);
///   }
///
///   Future<void> _onLoad(
///     LoadWalletListAction action,
///     Emitter<WalletListState> emit,
///   ) async {
///     emit(const WalletListLoading());
///     final result = await _getWalletListUseCase();
///     result.fold(
///       (failure) => emit(WalletListError(failure.message)),
///       (data) => emit(WalletListSuccess(data)),
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
class WalletListBloc extends MviBloc<WalletListAction, WalletListState, WalletListEvent> {
  final GetWalletUseCase _getWalletUseCase;

  WalletListBloc(this._getWalletUseCase) : super(const WalletListInitial()) {
    handleActionDroppable<LoadWalletListAction>(_onLoad);
  }

  Future<void> _onLoad(LoadWalletListAction action, Emitter<WalletListState> emit) async {
    emit(const WalletListLoading());
    final result = await _getWalletUseCase();
    result.fold(
      (failure) => emit(WalletListError(failure.message)),
      (data) => emit(WalletListSuccess(data)),
    );
  }
}
