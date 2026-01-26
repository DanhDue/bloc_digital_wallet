// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when adding action handlers
// import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/architecture/architecture.dart';
import 'token_list_action.dart';
import 'token_list_state.dart';
import 'token_list_event.dart';

/// ============================================================================
/// TokenList BLoC
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
/// class TokenListBloc extends MviBloc<...> {
///   final GetTokenListUseCase _getTokenListUseCase;
///
///   TokenListBloc(this._getTokenListUseCase)
///       : super(const TokenListInitial()) {
///     handleActionDroppable<LoadTokenListAction>(_onLoad);
///   }
///
///   Future<void> _onLoad(
///     LoadTokenListAction action,
///     Emitter<TokenListState> emit,
///   ) async {
///     emit(const TokenListLoading());
///     final result = await _getTokenListUseCase();
///     result.fold(
///       (failure) => emit(TokenListError(failure.message)),
///       (data) => emit(TokenListSuccess(data)),
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
class TokenListBloc extends MviBloc<TokenListAction, TokenListState, TokenListEvent> {
  TokenListBloc() : super(const TokenListInitial()) {
    // TODO: Register action handlers here
    // handleActionDroppable<LoadTokenListAction>(_onLoad);
  }

  // TODO: Implement action handlers
  // Future<void> _onLoad(
  //   LoadTokenListAction action,
  //   Emitter<TokenListState> emit,
  // ) async {
  //   // Handle loading
  // }
}
