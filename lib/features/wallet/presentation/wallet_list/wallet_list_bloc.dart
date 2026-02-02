// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:math';
import 'package:injectable/injectable.dart';
// TODO: Uncomment when adding action handlers
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_wallet_usecase.dart';
import '../../domain/usecases/get_token_accounts_usecase.dart';

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
@injectable
class WalletListBloc extends MviBloc<WalletListAction, WalletListState, WalletListEvent> {
  final GetWalletUseCase _getWalletUseCase;
  final GetTokenAccountsUseCase _getTokenAccountsUseCase;

  WalletListBloc(this._getWalletUseCase, this._getTokenAccountsUseCase)
    : super(const WalletListInitial()) {
    handleActionDroppable<LoadWalletListAction>(_onLoad);
    handleActionDroppable<ToggleBalanceVisibility>(_onToggleVisibility);
  }

  Future<void> _onLoad(LoadWalletListAction action, Emitter<WalletListState> emit) async {
    emit(const WalletListLoading());
    final result = await _getWalletUseCase();

    await result.fold((failure) async => emit(WalletListError(failure.message)), (wallets) async {
      // Emit initial state with wallets immediately, showing loading shimmer
      emit(WalletListSuccess(wallets, isBalanceLoading: true));

      // Calculate total balance for each wallet asynchronously in parallel
      final updatedWallets = await Future.wait(
        wallets.map((wallet) async {
          final tokenResult = await _getTokenAccountsUseCase(wallet.address ?? '');

          return tokenResult.fold(
            (failure) => wallet, // If token fetch fails, keep original balance (usually 0)
            (tokens) {
              // Sum up the value of all tokens and calculate weighted trend.
              // Assuming 1 unit of token amount = 1 USD for now based on TokenUiModel logic.
              double totalBalance = 0.0;
              double totalValueChange = 0.0;

              for (final token in tokens) {
                final balance = token.amount ?? 0.0;
                totalBalance += balance;

                // Generate random trend for this token (simulation) matching TokenUiModel
                final random = Random(token.address.hashCode);
                final isPositive = random.nextBool();
                final percentChange = (random.nextDouble() * 14.9) + 0.1;
                final signedPercent = isPositive ? percentChange : -percentChange;

                // Value change = Balance * (Percent / 100)
                final valueChange = balance * (signedPercent / 100);
                totalValueChange += valueChange;
              }

              final dailyChange = totalBalance == 0
                  ? 0.0
                  : (totalValueChange / totalBalance) * 100;

              return wallet.copyWith(balance: totalBalance, dailyChange: dailyChange);
            },
          );
        }),
      );

      // Emit updated state with calculated balances
      // Check if state is still Success to preserve isBalanceHidden
      if (state is WalletListSuccess) {
        final isHidden = (state as WalletListSuccess).isBalanceHidden;
        emit(
          WalletListSuccess(updatedWallets, isBalanceHidden: isHidden, isBalanceLoading: false),
        );
      } else {
        emit(WalletListSuccess(updatedWallets, isBalanceLoading: false));
      }
    });
  }

  void _onToggleVisibility(ToggleBalanceVisibility action, Emitter<WalletListState> emit) {
    if (state is WalletListSuccess) {
      final currentState = state as WalletListSuccess;
      emit(
        WalletListSuccess(currentState.wallets, isBalanceHidden: !currentState.isBalanceHidden),
      );
    }
  }
}
