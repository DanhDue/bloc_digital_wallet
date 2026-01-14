// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di/injection.dart';
import '{{{subfeature_name.snakeCase()}}}_bloc.dart';
import '{{{subfeature_name.snakeCase()}}}_state.dart';
import '{{{subfeature_name.snakeCase()}}}_event.dart';
// TODO: Uncomment when dispatching actions
// import '{{{subfeature_name.snakeCase()}}}_action.dart';

/// ============================================================================
/// {{subfeature_name.pascalCase()}} Page
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
/// BlocBuilder<{{subfeature_name.pascalCase()}}Bloc, {{subfeature_name.pascalCase()}}State>(
///   builder: (context, state) {
///     return switch (state) {
///       {{subfeature_name.pascalCase()}}Initial() => _buildInitial(),
///       {{subfeature_name.pascalCase()}}Loading() => const CircularProgressIndicator(),
///       {{subfeature_name.pascalCase()}}Success(:final items) => _buildList(items),
///       {{subfeature_name.pascalCase()}}Error(:final message) => _buildError(message),
///     };
///   },
/// )
/// ```
/// ============================================================================

@RoutePage()
class {{subfeature_name.pascalCase()}}Page extends StatelessWidget {
  const {{subfeature_name.pascalCase()}}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<{{subfeature_name.pascalCase()}}Bloc>(),
      child: const _{{subfeature_name.pascalCase()}}View(),
    );
  }
}

class _{{subfeature_name.pascalCase()}}View extends StatelessWidget {
  const _{{subfeature_name.pascalCase()}}View();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('{{subfeature_name.titleCase()}}'),
      ),
      body: BlocConsumer<{{subfeature_name.pascalCase()}}Bloc, {{subfeature_name.pascalCase()}}State>(
        listener: (context, state) {
          // Listen to one-time events (navigation, snackbar, dialog)
          // State is passed to access current data during event handling
          context.read<{{subfeature_name.pascalCase()}}Bloc>().events.listen((event) {
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
  Widget _handleState(BuildContext context, {{subfeature_name.pascalCase()}}State state) {
    return switch (state) {
      {{subfeature_name.pascalCase()}}Initial() => _buildInitial(context),
      // TODO: Add cases for other states
      // {{subfeature_name.pascalCase()}}Loading() => const Center(child: CircularProgressIndicator()),
      // {{subfeature_name.pascalCase()}}Success(:final items) => _buildSuccess(context, items),
      // {{subfeature_name.pascalCase()}}Error(:final message) => _buildError(context, message),
    };
  }

  /// ============================================================================
  /// Event Handling
  /// ============================================================================
  /// Events are one-time side effects. State is passed to access current data.
  /// ============================================================================
  void _handleEvent(
    BuildContext context,
    {{subfeature_name.pascalCase()}}State state,
    {{subfeature_name.pascalCase()}}Event event,
  ) {
    // TODO: Handle events with switch
    // switch (event) {
    //   case ShowMessage(:final message, :final type):
    //     // Show snackbar
    //     break;
    //   case NavigateBackEvent():
    //     // Access state data: if (state is {{subfeature_name.pascalCase()}}Success) { ... }
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
    return const Center(
      child: Text('{{subfeature_name.titleCase()}} Subfeature'),
    );
  }

}
