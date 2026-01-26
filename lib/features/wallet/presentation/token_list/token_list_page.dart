// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:bloc_digital_wallet/core/architecture/architecture.dart';
import 'token_list_bloc.dart';
import 'token_list_state.dart';
import 'token_list_event.dart';
// TODO: Uncomment when dispatching actions
// import 'token_list_action.dart';

/// ============================================================================
/// TokenList Page
/// ============================================================================
/// MVI Page - Only implement the MVI methods:
/// - buildAppBar: Optional app bar
/// - handleState: Build UI based on state
/// - handleEvent: Handle one-time events
/// - onBlocCreated: Optional initial action
/// ============================================================================

@RoutePage()
class TokenListPage extends BaseMviPage<TokenListBloc, TokenListState, TokenListEvent> {
  const TokenListPage({super.key});

  // TODO: Uncomment to dispatch initial action
  // @override
  // BaseAction? get initialAction => const LoadTokenListAction();

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(title: const Text('Token List'));
  }

  @override
  Widget handleState(BuildContext context, TokenListState state) {
    return switch (state) {
      TokenListInitial() => _buildInitial(context),
      // TODO: Add cases for other states
      // TokenListLoading() => const Center(child: CircularProgressIndicator()),
      // TokenListSuccess(:final items) => _buildSuccess(context, items),
      // TokenListError(:final message) => _buildError(context, message),
    };
  }

  @override
  void handleEvent(BuildContext context, TokenListEvent event) {
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
    return const Center(child: Text('Token List Subfeature'));
  }
}
