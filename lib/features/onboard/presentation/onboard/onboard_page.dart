// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di/injection.dart';
import 'onboard_bloc.dart';
import 'onboard_state.dart';
import 'onboard_event.dart';
// TODO: Uncomment when dispatching actions
// import 'onboard_action.dart';

/// ============================================================================
/// Onboard Page
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
/// BlocBuilder<OnboardBloc, OnboardState>(
///   builder: (context, state) {
///     return switch (state) {
///       OnboardInitial() => _buildInitial(),
///       OnboardLoading() => const CircularProgressIndicator(),
///       OnboardSuccess(:final items) => _buildList(items),
///       OnboardError(:final message) => _buildError(message),
///     };
///   },
/// )
/// ```
/// ============================================================================

@RoutePage()
class OnboardPage extends StatelessWidget {
  const OnboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<OnboardBloc>(), child: const _OnboardView());
  }
}

class _OnboardView extends StatelessWidget {
  const _OnboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboard')),
      body: BlocConsumer<OnboardBloc, OnboardState>(
        listener: (context, state) {
          // Listen to one-time events (navigation, snackbar, dialog)
          // State is passed to access current data during event handling
          context.read<OnboardBloc>().events.listen((event) {
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
  Widget _handleState(BuildContext context, OnboardState state) {
    return switch (state) {
      OnboardInitial() => _buildInitial(context),
      // TODO: Add cases for other states
      // OnboardLoading() => const Center(child: CircularProgressIndicator()),
      // OnboardSuccess(:final items) => _buildSuccess(context, items),
      // OnboardError(:final message) => _buildError(context, message),
    };
  }

  /// ============================================================================
  /// Event Handling
  /// ============================================================================
  /// Events are one-time side effects. State is passed to access current data.
  /// ============================================================================
  void _handleEvent(BuildContext context, OnboardState state, OnboardEvent event) {
    // TODO: Handle events with switch
    // switch (event) {
    //   case ShowMessage(:final message, :final type):
    //     // Show snackbar
    //     break;
    //   case NavigateBackEvent():
    //     // Access state data: if (state is OnboardSuccess) { ... }
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
    return const Center(child: Text('Onboard Feature'));
  }
}
