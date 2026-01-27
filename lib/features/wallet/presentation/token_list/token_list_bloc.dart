// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when adding action handlers
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_digital_wallet/core/components/infinite_list/base_infinite_list_bloc.dart';
import 'package:bloc_digital_wallet/core/components/infinite_list/base_infinite_list_event.dart';

import 'package:bloc_digital_wallet/features/wallet/domain/usecases/get_token_accounts_usecase.dart';
import 'package:bloc_digital_wallet/features/wallet/presentation/models/token_ui_model.dart';
// import 'token_list_action.dart';
// import 'token_list_state.dart';
// import 'token_list_event.dart';

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
class TokenListBloc extends BaseInfiniteListBloc<TokenUiModel> {
  final GetTokenAccountsUseCase _getTokenAccountsUseCase;

  String? _walletAddress;

  TokenListBloc(this._getTokenAccountsUseCase);

  void updateWalletAddress(String address) {
    _walletAddress = address;
    add(const InfiniteListFetchFirstPage());
  }

  @override
  Future<List<TokenUiModel>> fetchItems({required int page, required int limit}) async {
    // Note: The API currently fetches ALL accounts for an address, pagination might not be supported individually
    // But BaseInfiniteListBloc expects pages.
    // If API returns all at once on page 0, subsequent pages should return empty.

    if (page > 0) return []; // Assuming single page response for now

    if (_walletAddress == null || _walletAddress!.isEmpty) return [];

    final result = await _getTokenAccountsUseCase(_walletAddress!);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (items) => items.map(TokenUiModel.fromEntity).toList(),
    );
  }
}
