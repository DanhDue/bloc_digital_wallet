// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:bloc_digital_wallet/core/architecture/architecture.dart';
import 'transaction_bloc.dart';
import 'transaction_state.dart';
import 'transaction_event.dart';
// TODO: Uncomment when dispatching actions
// import 'transaction_action.dart';

/// ============================================================================
/// Transaction Page
/// ============================================================================
/// MVI Page - Only implement the MVI methods:
/// - buildAppBar: Optional app bar
/// - handleState: Build UI based on state
/// - handleEvent: Handle one-time events
/// - onBlocCreated: Optional initial action
/// ============================================================================

@RoutePage()
class TransactionPage extends BaseMviPage<TransactionBloc, TransactionState, TransactionEvent> {
  const TransactionPage({super.key});

  // TODO: Uncomment to dispatch initial action
  // @override
  // void Function(TransactionBloc bloc)? get onBlocCreated =>
  //     (bloc) => bloc.onAction(const LoadTransactionAction());

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(title: const Text('Transaction'));
  }

  @override
  Widget handleState(BuildContext context, TransactionState state) {
    return switch (state) {
      TransactionInitial() => _buildInitial(context),
      // TODO: Add cases for other states
      // TransactionLoading() => const Center(child: CircularProgressIndicator()),
      // TransactionSuccess(:final data) => _buildSuccess(context, data),
      // TransactionError(:final message) => _buildError(context, message),
    };
  }

  @override
  void handleEvent(BuildContext context, TransactionEvent event) {
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
    return const Center(child: Text('Transaction Feature'));
  }
}
