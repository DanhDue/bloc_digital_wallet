// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di/injection.dart';
import 'dashboard_bloc.dart';
import 'dashboard_state.dart';
import 'dashboard_event.dart';
import 'dashboard_action.dart';

/// ============================================================================
/// Dashboard Page
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
/// BlocBuilder<DashboardBloc, DashboardState>(
///   builder: (context, state) {
///     return switch (state) {
///       DashboardInitial() => _buildInitial(),
///       DashboardLoading() => const CircularProgressIndicator(),
///       DashboardSuccess(:final items) => _buildList(items),
///       DashboardError(:final message) => _buildError(message),
///     };
///   },
/// )
/// ```
/// ============================================================================

@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<DashboardBloc>(), child: const _DashboardView());
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: _handleEvent,
        builder: (context, state) {
          return switch (state) {
            DashboardInitial() => _buildInitial(context),
            // TODO: Add cases for other states
          };
        },
      ),
    );
  }

  void _handleEvent(BuildContext context, DashboardState state) {
    // TODO: Handle events here (navigation, snackbar, dialog)
    // Use BlocListener separately if needed for events
  }

  Widget _buildInitial(BuildContext context) {
    return const Center(child: Text('Dashboard Feature'));
  }
}
