// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:framework/framework.dart';
import 'package:flutter/material.dart';

import 'nfts_list_action.dart';
import 'nfts_list_bloc.dart';
import 'nfts_list_event.dart';
import 'nfts_list_state.dart';

@RoutePage()
class NftsListPage extends BaseMviPage<NftsListBloc, NftsListState, NftsListEvent> {
  const NftsListPage({super.key});

  @override
  BaseAction? get initialAction => const NftsListAction.started();

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(title: const Text('Nfts List'));
  }

  @override
  Widget handleState(BuildContext context, NftsListState state) {
    return switch (state.status) {
      NftsListStatus.initial => const Center(child: Text('Initial')),
      NftsListStatus.loading => const Center(child: CircularProgressIndicator()),
      NftsListStatus.success => _buildContent(context, state),
      NftsListStatus.failure => Center(child: Text(state.errorMessage ?? 'Error')),
    };
  }

  @override
  void handleEvent(BuildContext context, NftsListEvent event) {
    event.when(initial: () {});
  }

  Widget _buildContent(BuildContext context, NftsListState state) {
    return Center(child: Text('Nfts List Subfeature'));
  }
}
