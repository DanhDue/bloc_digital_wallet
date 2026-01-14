// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di/injection.dart';
import 'profile_bloc.dart';
import 'profile_state.dart';
import 'profile_event.dart';
// TODO: Uncomment when dispatching actions
// import 'profile_action.dart';

/// ============================================================================
/// Profile Page
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
/// BlocBuilder<ProfileBloc, ProfileState>(
///   builder: (context, state) {
///     return switch (state) {
///       ProfileInitial() => _buildInitial(),
///       ProfileLoading() => const CircularProgressIndicator(),
///       ProfileSuccess(:final items) => _buildList(items),
///       ProfileError(:final message) => _buildError(message),
///     };
///   },
/// )
/// ```
/// ============================================================================

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<ProfileBloc>(), child: const _ProfileView());
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          // Listen to one-time events (navigation, snackbar, dialog)
          // State is passed to access current data during event handling
          context.read<ProfileBloc>().events.listen((event) {
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
  Widget _handleState(BuildContext context, ProfileState state) {
    return switch (state) {
      ProfileInitial() => _buildInitial(context),
      // TODO: Add cases for other states
      // ProfileLoading() => const Center(child: CircularProgressIndicator()),
      // ProfileSuccess(:final items) => _buildSuccess(context, items),
      // ProfileError(:final message) => _buildError(context, message),
    };
  }

  /// ============================================================================
  /// Event Handling
  /// ============================================================================
  /// Events are one-time side effects. State is passed to access current data.
  /// ============================================================================
  void _handleEvent(BuildContext context, ProfileState state, ProfileEvent event) {
    // TODO: Handle events with switch
    // switch (event) {
    //   case ShowMessage(:final message, :final type):
    //     // Show snackbar
    //     break;
    //   case NavigateBackEvent():
    //     // Access state data: if (state is ProfileSuccess) { ... }
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
    return const Center(child: Text('Profile Subfeature'));
  }
}
