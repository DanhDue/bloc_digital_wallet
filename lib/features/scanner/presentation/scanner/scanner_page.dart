// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:bloc_digital_wallet/core/architecture/architecture.dart';
import 'scanner_bloc.dart';
import 'scanner_state.dart';
import 'scanner_event.dart';
// TODO: Uncomment when dispatching actions
// import 'scanner_action.dart';

/// ============================================================================
/// Scanner Page
/// ============================================================================
/// MVI Page - Only implement the MVI methods:
/// - buildAppBar: Optional app bar
/// - handleState: Build UI based on state
/// - handleEvent: Handle one-time events
/// - onBlocCreated: Optional initial action
/// ============================================================================

@RoutePage()
class ScannerPage extends BaseMviPage<ScannerBloc, ScannerState, ScannerEvent> {
  const ScannerPage({super.key});

  // TODO: Uncomment to dispatch initial action
  // @override
  // void Function(ScannerBloc bloc)? get onBlocCreated =>
  //     (bloc) => bloc.onAction(const LoadScannerAction());

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(title: const Text('Scanner'));
  }

  @override
  Widget handleState(BuildContext context, ScannerState state) {
    return switch (state) {
      ScannerInitial() => _buildInitial(context),
      // TODO: Add cases for other states
      // ScannerLoading() => const Center(child: CircularProgressIndicator()),
      // ScannerSuccess(:final data) => _buildSuccess(context, data),
      // ScannerError(:final message) => _buildError(context, message),
    };
  }

  @override
  void handleEvent(BuildContext context, ScannerEvent event) {
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
    return const Center(child: Text('Scanner Feature'));
  }
}
