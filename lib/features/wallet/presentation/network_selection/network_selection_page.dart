// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:bloc_digital_wallet/core/architecture/architecture.dart';
import 'network_selection_bloc.dart';
import 'network_selection_state.dart';
import 'network_selection_event.dart';
// TODO: Uncomment when dispatching actions
// import 'network_selection_action.dart';

/// ============================================================================
/// NetworkSelection Page
/// ============================================================================
/// MVI Page - Only implement the MVI methods:
/// - buildAppBar: Optional app bar
/// - handleState: Build UI based on state
/// - handleEvent: Handle one-time events
/// - onBlocCreated: Optional initial action
/// ============================================================================

@RoutePage()
class NetworkSelectionPage
    extends BaseMviPage<NetworkSelectionBloc, NetworkSelectionState, NetworkSelectionEvent> {
  const NetworkSelectionPage({super.key});

  // TODO: Uncomment to dispatch initial action
  // @override
  // void Function(NetworkSelectionBloc bloc)? get onBlocCreated =>
  //     (bloc) => bloc.onAction(const LoadNetworkSelectionAction());

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(title: const Text('Network Selection'));
  }

  @override
  Widget handleState(BuildContext context, NetworkSelectionState state) {
    return switch (state) {
      NetworkSelectionInitial() => _buildInitial(context),
      // TODO: Add cases for other states
      // NetworkSelectionLoading() => const Center(child: CircularProgressIndicator()),
      // NetworkSelectionSuccess(:final items) => _buildSuccess(context, items),
      // NetworkSelectionError(:final message) => _buildError(context, message),
    };
  }

  @override
  void handleEvent(BuildContext context, NetworkSelectionEvent event) {
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
    return const Center(child: Text('Network Selection Subfeature'));
  }
}
