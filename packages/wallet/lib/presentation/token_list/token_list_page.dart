// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:framework/framework.dart';
import 'package:flutter/material.dart';

import 'token_list_action.dart';
import 'token_list_bloc.dart';
import 'token_list_event.dart';
import 'token_list_state.dart';

@RoutePage()
class TokenListPage extends BaseMviPage<TokenListBloc, TokenListState, TokenListEvent> {
  const TokenListPage({super.key});

  @override
  BaseAction? get initialAction => const TokenListAction.started();

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(title: const Text('Token List'));
  }

  @override
  Widget handleState(BuildContext context, TokenListState state) {
    return switch (state.status) {
      TokenListStatus.initial => const Center(child: Text('Initial')),
      TokenListStatus.loading => const Center(child: CircularProgressIndicator()),
      TokenListStatus.success => _buildContent(context, state),
      TokenListStatus.failure => Center(child: Text(state.errorMessage ?? 'Error')),
    };
  }

  @override
  void handleEvent(BuildContext context, TokenListEvent event) {
    event.when(initial: () {});
  }

  Widget _buildContent(BuildContext context, TokenListState state) {
    return Center(child: Text('Token List Subfeature'));
  }
}
