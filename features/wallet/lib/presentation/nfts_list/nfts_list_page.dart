// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:framework/framework.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:wallet/wallet_strings.dart';

import 'nfts_list_action.dart';
import 'nfts_list_bloc.dart';
import 'nfts_list_event.dart';
import 'nfts_list_state.dart';

@RoutePage()
class NftsListPage
    extends BaseMviPage<NftsListBloc, NftsListAction, NftsListState, NftsListEvent> {
  const NftsListPage({super.key});

  @override
  NftsListAction? get initialAction => const NftsListAction.started();

  @override
  Widget buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget handleState(BuildContext context, NftsListState state) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      child: switch (state.status) {
        NftsListStatus.initial => _buildEmptyState(context),
        NftsListStatus.loading => const Center(child: CircularProgressIndicator()),
        NftsListStatus.success => _buildContent(context, state),
        NftsListStatus.failure => Center(
          child: Text(state.errorMessage ?? WalletStrings.t.wallet.nftsList.error),
        ),
      },
    );
  }

  @override
  void handleEvent(BuildContext context, NftsListEvent event) {
    event.when(initial: () {});
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      children: [
        const SizedBox(height: 16),
        Center(
          child: Column(
            mainAxisSize: .min,
            children: [
              const SizedBox(height: 36),
              Icon(Icons.image_not_supported_outlined, size: 86, color: context.appThemes.ink40),
              const SizedBox(height: 4),
              Text(
                WalletStrings.t.wallet.nftsList.notFoundMessage,
                style: context.appThemes.bodyMedium.copyWith(color: context.appThemes.ink40),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => debugPrint('Add NFT'),
                child: Text(WalletStrings.t.wallet.nftsList.addNft),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, NftsListState state) {
    // TODO: Implement list when data is available
    return const Center(child: Text('NFTs List'));
  }
}
