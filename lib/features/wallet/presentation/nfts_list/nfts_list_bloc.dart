// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when adding action handlers
// import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/architecture/architecture.dart';
import 'nfts_list_action.dart';
import 'nfts_list_state.dart';
import 'nfts_list_event.dart';

/// ============================================================================
/// NftsList BLoC
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
/// class NftsListBloc extends MviBloc<...> {
///   final GetNftsListUseCase _getNftsListUseCase;
///
///   NftsListBloc(this._getNftsListUseCase)
///       : super(const NftsListInitial()) {
///     handleActionDroppable<LoadNftsListAction>(_onLoad);
///   }
///
///   Future<void> _onLoad(
///     LoadNftsListAction action,
///     Emitter<NftsListState> emit,
///   ) async {
///     emit(const NftsListLoading());
///     final result = await _getNftsListUseCase();
///     result.fold(
///       (failure) => emit(NftsListError(failure.message)),
///       (data) => emit(NftsListSuccess(data)),
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
class NftsListBloc extends MviBloc<NftsListAction, NftsListState, NftsListEvent> {
  NftsListBloc() : super(const NftsListInitial()) {
    // TODO: Register action handlers here
    // handleActionDroppable<LoadNftsListAction>(_onLoad);
  }

  // TODO: Implement action handlers
  // Future<void> _onLoad(
  //   LoadNftsListAction action,
  //   Emitter<NftsListState> emit,
  // ) async {
  //   // Handle loading
  // }
}
