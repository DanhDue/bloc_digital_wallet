// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:bloc_digital_wallet/core/architecture/architecture.dart';
import 'd3_votion_bloc.dart';
import 'd3_votion_state.dart';
import 'd3_votion_event.dart';
// TODO: Uncomment when dispatching actions
// import 'd3_votion_action.dart';

/// ============================================================================
/// D3Votion Page
/// ============================================================================
/// MVI Page - Only implement the MVI methods:
/// - buildAppBar: Optional app bar
/// - handleState: Build UI based on state
/// - handleEvent: Handle one-time events
/// - onBlocCreated: Optional initial action
/// ============================================================================

@RoutePage()
class D3VotionPage extends BaseMviPage<D3VotionBloc, D3VotionState, D3VotionEvent> {
  const D3VotionPage({super.key});

  // TODO: Uncomment to dispatch initial action
  // @override
  // void Function(D3VotionBloc bloc)? get onBlocCreated =>
  //     (bloc) => bloc.onAction(const LoadD3VotionAction());

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(title: const Text('D3 Votion'));
  }

  @override
  Widget handleState(BuildContext context, D3VotionState state) {
    return switch (state) {
      D3VotionInitial() => _buildInitial(context),
      // TODO: Add cases for other states
      // D3VotionLoading() => const Center(child: CircularProgressIndicator()),
      // D3VotionSuccess(:final data) => _buildSuccess(context, data),
      // D3VotionError(:final message) => _buildError(context, message),
    };
  }

  @override
  void handleEvent(BuildContext context, D3VotionEvent event) {
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
    return const Center(child: Text('D3 Votion Feature'));
  }
}
