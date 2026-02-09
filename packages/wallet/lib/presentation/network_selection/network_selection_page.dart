// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framework/framework.dart';
import 'package:wallet/wallet_strings.dart';

import 'network_selection_action.dart';
import 'network_selection_bloc.dart';
import 'network_selection_event.dart';
import 'network_selection_state.dart';

@RoutePage()
class NetworkSelectionPage
    extends
        BaseMviPage<
          NetworkSelectionBloc,
          NetworkSelectionAction,
          NetworkSelectionState,
          NetworkSelectionEvent
        > {
  const NetworkSelectionPage({super.key});

  @override
  NetworkSelectionAction? get initialAction => const NetworkSelectionAction.load();

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildScaffold(BuildContext context) => buildBody(context);

  @override
  Widget handleState(BuildContext context, NetworkSelectionState state) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildSearchBar(context),
          const SizedBox(height: 16),
          _buildNetworkList(context, state),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 24),
        Text(
          WalletStrings.t.networkSelection.selectNetwork,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        InkWell(
          onTap: () => context.router.maybePop(),
          child: const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.close, size: 24)),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: .circular(8),
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: WalletStrings.t.networkSelection.search,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(Icons.search, size: 20, color: Theme.of(context).primaryColor),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: (value) =>
            context.read<NetworkSelectionBloc>().add(NetworkSelectionAction.search(value)),
      ),
    );
  }

  Widget _buildNetworkList(BuildContext context, NetworkSelectionState state) {
    return Flexible(
      child: switch (state.status) {
        NetworkSelectionStatus.initial ||
        NetworkSelectionStatus.loading => const Center(child: CircularProgressIndicator()),
        NetworkSelectionStatus.failure => Center(
          child: Text(state.errorMessage ?? WalletStrings.t.networkSelection.error),
        ),
        NetworkSelectionStatus.success => ListView.builder(
          shrinkWrap: true,
          itemCount: state.uiModel.networks.length,
          itemBuilder: (context, index) {
            final item = state.uiModel.networks[index];
            return ListTile(
              leading: _buildNetworkIcon(context, item.logo),
              title: Text(item.name ?? ''),
              onTap: () => context.router.maybePop(item),
            );
          },
        ),
      },
    );
  }

  Widget _buildNetworkIcon(BuildContext context, String? logo) {
    if (logo != null && logo.isNotEmpty) {
      return SizedBox(
        width: 48,
        height: 48,
        child: ClipRRect(
          borderRadius: .circular(48),
          child: Image.network(
            logo,
            width: 24,
            height: 24,
            errorBuilder: (_, _, _) => const Icon(Icons.error),
          ),
        ),
      );
    }
    return SizedBox(
      width: 48,
      height: 48,
      child: Icon(Icons.connected_tv_outlined, size: 36, color: Theme.of(context).primaryColor),
    );
  }

  @override
  void handleEvent(BuildContext context, NetworkSelectionEvent event) {
    event.when(initial: () {});
  }
}
