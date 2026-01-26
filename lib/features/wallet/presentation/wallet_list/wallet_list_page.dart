// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:bloc_digital_wallet/core/architecture/architecture.dart';
import 'wallet_list_bloc.dart';
import 'wallet_list_state.dart';
import 'wallet_list_event.dart';
import 'wallet_list_action.dart';
import 'widgets/wallet_item.dart';
import '../../domain/entities/wallet_entity.dart';

/// ============================================================================
/// WalletList Page
/// ============================================================================
/// MVI Page - Only implement the MVI methods:
/// - buildAppBar: Optional app bar
/// - handleState: Build UI based on state
/// - handleEvent: Handle one-time events
/// - onBlocCreated: Optional initial action
/// ============================================================================

@RoutePage()
class WalletListPage extends BaseMviPage<WalletListBloc, WalletListState, WalletListEvent> {
  final void Function(WalletEntity)? onWalletChanged;
  final WalletEntity? selectedWallet;

  const WalletListPage({super.key, this.onWalletChanged, this.selectedWallet});

  @override
  BaseAction? get initialAction => const LoadWalletListAction();

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildScaffold(BuildContext context) => buildBody(context);

  @override
  Widget handleState(BuildContext context, WalletListState state) {
    return switch (state) {
      WalletListInitial() => _buildLoading(context),
      WalletListLoading() => _buildLoading(context),
      WalletListSuccess(:final wallets) => _buildSuccess(context, wallets),
      WalletListError(:final message) => _buildError(context, message),
    };
  }

  @override
  void handleEvent(BuildContext context, WalletListEvent event) {
    // switch (event) {
    //   case ShowMessage(:final message, :final type):
    //     // Show snackbar
    //     break;
    // }
  }

  /// ============================================================================
  /// State Widgets
  /// ============================================================================
  Widget _buildLoading(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(child: Text(message));
  }

  Widget _buildSuccess(BuildContext context, List<WalletEntity> wallets) {
    if (wallets.isEmpty) {
      return const Center(child: Text('No wallets found'));
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
        return WalletItem(wallet: wallets[index], index: index);
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
