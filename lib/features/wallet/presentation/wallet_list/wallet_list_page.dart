// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:bloc_digital_wallet/core/architecture/architecture.dart';
import 'wallet_list_bloc.dart';
import 'wallet_list_state.dart';
import 'wallet_list_event.dart';
// TODO: Uncomment when dispatching actions
// import 'wallet_list_action.dart';

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
  const WalletListPage({super.key});

  // TODO: Uncomment to dispatch initial action
  // @override
  // BaseAction? get initialAction => const LoadWalletListAction();

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(title: const Text('Wallet List'));
  }

  @override
  Widget handleState(BuildContext context, WalletListState state) {
    return switch (state) {
      WalletListInitial() => _buildInitial(context),
      // TODO: Add cases for other states
      // WalletListLoading() => const Center(child: CircularProgressIndicator()),
      // WalletListSuccess(:final items) => _buildSuccess(context, items),
      // WalletListError(:final message) => _buildError(context, message),
    };
  }

  @override
  void handleEvent(BuildContext context, WalletListEvent event) {
    // TODO: Handle events with switch
    // switch (event) {
    //   case ShowMessage(:final message, :final type):
    //     // Show snackbar
    //     break;
    //   case NavigateBackEvent():
    //     context.router.pop();
    //     break;
    // }
  }

  /// ============================================================================
  /// State Widgets
  /// ============================================================================
  Widget _buildInitial(BuildContext context) {
    return const Center(child: Text('Wallet List Subfeature'));
  }
}
