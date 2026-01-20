// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:bloc_digital_wallet/core/architecture/architecture.dart';
import 'start_bloc.dart';
import 'start_state.dart';
import 'start_event.dart';
// TODO: Uncomment when dispatching actions
// import 'start_action.dart';

/// ============================================================================
/// Start Page
/// ============================================================================
/// MVI Page - Only implement the MVI methods:
/// - buildAppBar: Optional app bar
/// - handleState: Build UI based on state
/// - handleEvent: Handle one-time events
/// - onBlocCreated: Optional initial action
/// ============================================================================

@RoutePage()
class StartPage extends BaseMviPage<StartBloc, StartState, StartEvent> {
  const StartPage({super.key});

  // TODO: Uncomment to dispatch initial action
  // @override
  // void Function(StartBloc bloc)? get onBlocCreated =>
  //     (bloc) => bloc.onAction(const LoadStartAction());

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(title: const Text('Start'));
  }

  @override
  Widget handleState(BuildContext context, StartState state) {
    return switch (state) {
      StartInitial() => _buildInitial(context),
      // TODO: Add cases for other states
      // StartLoading() => const Center(child: CircularProgressIndicator()),
      // StartSuccess(:final items) => _buildSuccess(context, items),
      // StartError(:final message) => _buildError(context, message),
    };
  }

  @override
  void handleEvent(BuildContext context, StartEvent event) {
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
    return const Center(child: Text('Start Subfeature'));
  }
}
