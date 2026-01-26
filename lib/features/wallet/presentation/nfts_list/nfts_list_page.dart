// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:bloc_digital_wallet/config/theme/app_themes.dart';
import 'package:bloc_digital_wallet/core/architecture/architecture.dart';
import 'package:bloc_digital_wallet/core/widgets/custom_unfilled_button.dart';
import 'package:bloc_digital_wallet/generated/assets.gen.dart';
import 'package:bloc_digital_wallet/generated/translations.dart';
import 'package:flutter/material.dart';

import 'nfts_list_bloc.dart';
import 'nfts_list_event.dart';
import 'nfts_list_state.dart';

@RoutePage()
class NftsListPage extends BaseMviPage<NftsListBloc, NftsListState, NftsListEvent> {
  const NftsListPage({super.key});

  // TODO: Uncomment to dispatch initial action
  // @override
  // BaseAction? get initialAction => const LoadNftsListAction();

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
      child: switch (state) {
        NftsListInitial() => _buildInitial(context),
        // TODO: Add cases for other states
        // NftsListLoading() => const Center(child: CircularProgressIndicator()),
        // NftsListSuccess(:final items) => _buildSuccess(context, items),
        // NftsListError(:final message) => _buildError(context, message),
      },
    );
  }

  @override
  void handleEvent(BuildContext context, NftsListEvent event) {
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

  Widget _buildInitial(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 36),
              Assets.images.icNoFound.svg(width: 86, fit: BoxFit.cover),
              const SizedBox(height: 4),
              Text(
                context.t.nftNotFoundMessage,
                style: context.appThemes.bodyMedium.copyWith(color: context.appThemes.ink60),
              ),
              const SizedBox(height: 4),
              CustomUnfilledButton(text: context.t.addNFT, onPressed: () => debugPrint("Add NFT")),
            ],
          ),
        ),
      ],
    );
  }
}
