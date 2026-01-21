// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:bloc_digital_wallet/core/architecture/architecture.dart';
import 'wallet_bloc.dart';
import 'wallet_state.dart';
import 'wallet_event.dart';
// TODO: Uncomment when dispatching actions
// import 'wallet_action.dart';

/// ============================================================================
/// Wallet Page
/// ============================================================================
/// MVI Page - Only implement the MVI methods:
/// - buildAppBar: Optional app bar
/// - handleState: Build UI based on state
/// - handleEvent: Handle one-time events
/// - onBlocCreated: Optional initial action
/// ============================================================================

@RoutePage()
class WalletPage extends BaseMviPage<WalletBloc, WalletState, WalletEvent> {
  const WalletPage({super.key});

  // TODO: Uncomment to dispatch initial action
  // @override
  // void Function(WalletBloc bloc)? get onBlocCreated =>
  //     (bloc) => bloc.onAction(const LoadWalletAction());

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(title: const Text('Wallet'));
  }

  @override
  Widget handleState(BuildContext context, WalletState state) {
    return switch (state) {
      WalletInitial() => _buildInitial(context),
      // TODO: Add cases for other states
      // WalletLoading() => const Center(child: CircularProgressIndicator()),
      // WalletSuccess(:final data) => _buildSuccess(context, data),
      // WalletError(:final message) => _buildError(context, message),
    };
  }

  @override
  void handleEvent(BuildContext context, WalletEvent event) {
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
    return const Center(child: Text('Wallet Feature'));
  }
}
