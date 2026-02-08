// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:wallet/wallet_strings.dart';

import 'models/token_list_ui_model.dart';
import 'token_list_bloc.dart';
import 'widgets/token_item_view.dart';

@RoutePage()
class TokenListPage extends BaseInfiniteListPage<TokenListBloc, TokenListUiModel> {
  final String? walletAddress;

  const TokenListPage({super.key, this.walletAddress});

  @override
  void onBlocCreated(BuildContext context, TokenListBloc bloc) {
    bloc.updateWalletAddress(walletAddress ?? '');
  }

  @override
  Widget buildItem(BuildContext context, TokenListUiModel item, int index) {
    return TokenItemView(token: item, isFirst: index == 0);
  }

  @override
  Widget buildEmpty(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      children: [
        const SizedBox(height: 36),
        Icon(Icons.token_outlined, size: 86, color: Theme.of(context).disabledColor),
        const SizedBox(height: 4),
        Text(
          WalletStrings.t.tokenList.notFoundMessage,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).disabledColor),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () => debugPrint('Add Token'),
          child: Text(WalletStrings.t.tokenList.addToken),
        ),
      ],
    );
  }
}
