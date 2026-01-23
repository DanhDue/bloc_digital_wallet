// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:bloc_digital_wallet/core/architecture/architecture.dart';
import 'trends_bloc.dart';
import 'trends_state.dart';
import 'trends_event.dart';
// TODO: Uncomment when dispatching actions
// import 'trends_action.dart';

/// ============================================================================
/// Trends Page
/// ============================================================================
/// MVI Page - Only implement the MVI methods:
/// - buildAppBar: Optional app bar
/// - handleState: Build UI based on state
/// - handleEvent: Handle one-time events
/// - onBlocCreated: Optional initial action
/// ============================================================================

@RoutePage()
class TrendsPage extends BaseMviPage<TrendsBloc, TrendsState, TrendsEvent> {
  const TrendsPage({super.key});

  // TODO: Uncomment to dispatch initial action
  // @override
  // void Function(TrendsBloc bloc)? get onBlocCreated =>
  //     (bloc) => bloc.onAction(const LoadTrendsAction());

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(title: const Text('Trends'));
  }

  @override
  Widget handleState(BuildContext context, TrendsState state) {
    return switch (state) {
      TrendsInitial() => _buildInitial(context),
      // TODO: Add cases for other states
      // TrendsLoading() => const Center(child: CircularProgressIndicator()),
      // TrendsSuccess(:final data) => _buildSuccess(context, data),
      // TrendsError(:final message) => _buildError(context, message),
    };
  }

  @override
  void handleEvent(BuildContext context, TrendsEvent event) {
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
    return const Center(child: Text('Trends Feature'));
  }
}
