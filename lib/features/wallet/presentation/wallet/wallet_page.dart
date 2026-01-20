// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di/injection.dart';
import 'wallet_bloc.dart';
import 'wallet_state.dart';
import 'wallet_event.dart';
// TODO: Uncomment when dispatching actions
// import 'wallet_action.dart';

/// ============================================================================
/// Wallet Page
/// ============================================================================
/// The UI layer that displays states and dispatches actions.
///
/// HOW TO EXTEND:
/// 1. Add UI widgets in the _buildContent method
/// 2. Handle different states in the BlocBuilder
/// 3. Handle events (navigation, snackbar) in BlocListener
/// 4. Dispatch actions via bloc.onAction(YourAction())
///
/// EXAMPLE - Handling multiple states:
/// ```dart
/// BlocBuilder<WalletBloc, WalletState>(
///   builder: (context, state) {
///     return switch (state) {
///       WalletInitial() => _buildInitial(),
///       WalletLoading() => const CircularProgressIndicator(),
///       WalletSuccess(:final items) => _buildList(items),
///       WalletError(:final message) => _buildError(message),
///     };
///   },
/// )
/// ```
/// ============================================================================

@RoutePage()
class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<WalletBloc>(), child: const _WalletView());
  }
}

class _WalletView extends StatelessWidget {
  const _WalletView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          // Listen to one-time events (navigation, snackbar, dialog)
          // State is passed to access current data during event handling
          context.read<WalletBloc>().events.listen((event) {
            if (!context.mounted) return;
            _handleEvent(context, state, event);
          });
        },
        builder: (context, state) => _handleState(context, state),
      ),
    );
  }

  /// ============================================================================
  /// State Handling
  /// ============================================================================
  /// States represent the UI at any given moment. Handle them here:
  /// ============================================================================
  Widget _handleState(BuildContext context, WalletState state) {
    return switch (state) {
      WalletInitial() => _buildInitial(context),
      // TODO: Add cases for other states
      // WalletLoading() => const Center(child: CircularProgressIndicator()),
      // WalletSuccess(:final items) => _buildSuccess(context, items),
      // WalletError(:final message) => _buildError(context, message),
    };
  }

  /// ============================================================================
  /// Event Handling
  /// ============================================================================
  /// Events are one-time side effects. State is passed to access current data.
  /// ============================================================================
  void _handleEvent(BuildContext context, WalletState state, WalletEvent event) {
    // TODO: Handle events with switch
    // switch (event) {
    //   case ShowMessage(:final message, :final type):
    //     // Show snackbar
    //     break;
    //   case NavigateBackEvent():
    //     // Access state data: if (state is WalletSuccess) { ... }
    //     context.router.pop();
    //     break;
    // }
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
