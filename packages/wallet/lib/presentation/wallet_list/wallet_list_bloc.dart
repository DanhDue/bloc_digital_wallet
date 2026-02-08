// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:math'; // For random simulation

import 'package:framework/framework.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet/domain/usecases/get_token_accounts_usecase.dart';
import 'package:wallet/domain/usecases/get_wallet_list_usecase.dart';
import 'package:wallet/presentation/wallet_list/wallet_list_action.dart';
import 'package:wallet/presentation/wallet_list/wallet_list_event.dart';
import 'package:wallet/presentation/wallet_list/wallet_list_state.dart';

@injectable
class WalletListBloc extends MviBloc<WalletListAction, WalletListState, WalletListEvent> {
  final GetWalletListUseCase _getWalletListUseCase;
  final GetTokenAccountsUseCase _getTokenAccountsUseCase;

  WalletListBloc(this._getWalletListUseCase, this._getTokenAccountsUseCase)
    : super(const WalletListState()) {
    on<WalletListAction>(_onAction);
  }

  Future<void> _onAction(WalletListAction action, Emitter<WalletListState> emit) async {
    await action.when(
      started: () => _onLoad(emit),
      toggleBalanceVisibility: () => _onToggleVisibility(emit),
    );
  }

  Future<void> _onLoad(Emitter<WalletListState> emit) async {
    emit(state.copyWith(status: WalletListStatus.loading));

    final result = await _getWalletListUseCase();

    await result.fold(
      (failure) async {
        emit(state.copyWith(status: WalletListStatus.failure, errorMessage: failure.message));
      },
      (data) async {
        // Initial success with wallets, still loading balances
        emit(
          state.copyWith(
            status: WalletListStatus.success,
            uiModel: state.uiModel.copyWith(wallets: data.wallets, isBalanceLoading: true),
          ),
        );

        // Fetch tokens for each wallet in parallel
        final updatedWallets = await Future.wait(
          data.wallets.map((wallet) async {
            final address = wallet.address;
            if (address == null || address.isEmpty) {
              return wallet;
            }

            final tokenResult = await _getTokenAccountsUseCase(address);

            return tokenResult.fold((failure) => wallet, (tokens) {
              double totalBalance = 0.0;
              double totalValueChange = 0.0;

              for (final token in tokens) {
                final balance = token.balance ?? 0.0;
                totalBalance += balance;

                // Simulation logic matching old bloc
                final random = Random(token.id.hashCode);
                final isPositive = random.nextBool();
                final percentChange = (random.nextDouble() * 14.9) + 0.1;
                final signedPercent = isPositive ? percentChange : -percentChange;

                final valueChange = balance * (signedPercent / 100);
                totalValueChange += valueChange;
              }

              final dailyChange = totalBalance == 0
                  ? 0.0
                  : (totalValueChange / totalBalance) * 100;

              return wallet.copyWith(balance: totalBalance, dailyChange: dailyChange);
            });
          }),
        );

        emit(
          state.copyWith(
            uiModel: state.uiModel.copyWith(wallets: updatedWallets, isBalanceLoading: false),
          ),
        );
      },
    );
  }

  Future<void> _onToggleVisibility(Emitter<WalletListState> emit) async {
    emit(
      state.copyWith(
        uiModel: state.uiModel.copyWith(isBalanceHidden: !state.uiModel.isBalanceHidden),
      ),
    );
  }
}
