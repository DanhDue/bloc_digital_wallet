// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:framework/framework.dart';
import 'package:flutter/material.dart';

import 'wallet_list_action.dart';
import 'wallet_list_bloc.dart';
import 'wallet_list_event.dart';
import 'wallet_list_state.dart';

@RoutePage()
class WalletListPage extends BaseMviPage<WalletListBloc, WalletListState, WalletListEvent> {
  const WalletListPage({super.key});

  @override
  BaseAction? get initialAction => const WalletListAction.started();

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(title: const Text('Wallet List'));
  }

  @override
  Widget handleState(BuildContext context, WalletListState state) {
    return switch (state.status) {
      WalletListStatus.initial => const Center(child: Text('Initial')),
      WalletListStatus.loading => const Center(child: CircularProgressIndicator()),
      WalletListStatus.success => _buildContent(context, state),
      WalletListStatus.failure => Center(child: Text(state.errorMessage ?? 'Error')),
    };
  }

  @override
  void handleEvent(BuildContext context, WalletListEvent event) {
    event.when(
      initial: () {},
    );
  }

  Widget _buildContent(BuildContext context, WalletListState state) {
    return Center(
      child: Text('Wallet List Subfeature'),
    );
  }
}
