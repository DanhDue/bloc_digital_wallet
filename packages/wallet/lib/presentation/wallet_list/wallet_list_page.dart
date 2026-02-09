// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framework/framework.dart';
import 'package:wallet/domain/entities/wallet_entity.dart';
import 'package:wallet/presentation/wallet_list/widgets/wallet_item.dart';

import 'wallet_list_action.dart';
import 'wallet_list_bloc.dart';
import 'wallet_list_event.dart';
import 'wallet_list_state.dart';

@RoutePage()
class WalletListPage
    extends BaseMviPage<WalletListBloc, WalletListAction, WalletListState, WalletListEvent> {
  final void Function(WalletEntity)? onWalletChanged;
  final WalletEntity? selectedWallet;

  const WalletListPage({super.key, this.onWalletChanged, this.selectedWallet});

  @override
  WalletListAction? get initialAction => const WalletListAction.started();

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildScaffold(BuildContext context) => buildBody(context);

  @override
  Widget handleState(BuildContext context, WalletListState state) {
    return switch (state.status) {
      WalletListStatus.initial => _buildLoading(context),
      WalletListStatus.loading => _buildLoading(context),
      WalletListStatus.success => _buildSuccess(context, state),
      WalletListStatus.failure => _buildError(context, state.errorMessage ?? 'Error'),
    };
  }

  @override
  void handleEvent(BuildContext context, WalletListEvent event) {
    event.when(initial: () {});
  }

  Widget _buildLoading(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(child: Text(message));
  }

  Widget _buildSuccess(BuildContext context, WalletListState state) {
    final wallets = state.uiModel.wallets;
    if (wallets.isEmpty) {
      return const Center(child: Text('No wallets found')); // TODO: Localize
    }

    // Trigger callback for the first item initially if no wallet is selected
    if (wallets.isNotEmpty && selectedWallet == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onWalletChanged?.call(wallets[0]);
      });
    }

    final initialIndex = selectedWallet != null ? wallets.indexOf(selectedWallet!) : 0;
    // Handle case where selectedWallet is not in list (e.g. network change)
    final safeIndex = initialIndex >= 0 ? initialIndex : 0;

    return Swiper(
      index: safeIndex,
      itemBuilder: (BuildContext context, int index) {
        return WalletItem(
          wallet: wallets[index],
          index: index,
          isBalanceHidden: state.uiModel.isBalanceHidden,
          isBalanceLoading: state.uiModel.isBalanceLoading,
          onToggleBalance: () =>
              context.read<WalletListBloc>().add(const WalletListAction.toggleBalanceVisibility()),
        );
      },
      itemCount: wallets.length,
      itemWidth: MediaQuery.of(context).size.width - 32,
      itemHeight: 186,
      layout: SwiperLayout.STACK,
      scale: 0.96,
      loop: false,
      onIndexChanged: (index) {
        onWalletChanged?.call(wallets[index]);
      },
    );
  }
}
