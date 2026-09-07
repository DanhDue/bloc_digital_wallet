// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:d3_nexus_shield/core/architecture/architecture.dart';
import '{{{feature_name.snakeCase()}}}_bloc.dart';
import '{{{feature_name.snakeCase()}}}_state.dart';
import '{{{feature_name.snakeCase()}}}_event.dart';
// TODO: Uncomment when dispatching actions
// import '{{{feature_name.snakeCase()}}}_action.dart';

/// ============================================================================
/// {{feature_name.pascalCase()}} Page
/// ============================================================================
/// MVI Page - Only implement the MVI methods:
/// - buildAppBar: Optional app bar
/// - handleState: Build UI based on state
/// - handleEvent: Handle one-time events
/// - onBlocCreated: Optional initial action
/// ============================================================================

@RoutePage()
class {{feature_name.pascalCase()}}Page extends BaseMviPage<{{feature_name.pascalCase()}}Bloc, {{feature_name.pascalCase()}}State, {{feature_name.pascalCase()}}Event> {
  const {{feature_name.pascalCase()}}Page({super.key});

  // TODO: Uncomment to dispatch initial action
  // @override
  // BaseAction? get initialAction => const Load{{feature_name.pascalCase()}}Action();

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(title: const Text('{{feature_name.titleCase()}}'));
  }

  @override
  Widget handleState(BuildContext context, {{feature_name.pascalCase()}}State state) {
    return switch (state) {
      {{feature_name.pascalCase()}}Initial() => _buildInitial(context),
      // TODO: Add cases for other states
      // {{feature_name.pascalCase()}}Loading() => const Center(child: CircularProgressIndicator()),
      // {{feature_name.pascalCase()}}Success(:final data) => _buildSuccess(context, data),
      // {{feature_name.pascalCase()}}Error(:final message) => _buildError(context, message),
    };
  }

  @override
  void handleEvent(BuildContext context, {{feature_name.pascalCase()}}Event event) {
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
    return const Center(child: Text('{{feature_name.titleCase()}} Feature'));
  }
}
