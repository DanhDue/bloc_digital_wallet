// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:bloc_digital_wallet/features/wallet/presentation/models/token_ui_model.dart';
import 'package:bloc_digital_wallet/features/wallet/presentation/token_list/widgets/token_item_view.dart';
import 'token_list_bloc.dart';
import 'package:bloc_digital_wallet/features/wallet/domain/entities/wallet_entity.dart';
import 'package:bloc_digital_wallet/core/components/infinite_list/base_infinite_list_page.dart';

@RoutePage()
class TokenListPage extends BaseInfiniteListPage<TokenListBloc, TokenUiModel> {
  final WalletEntity? wallet;

  const TokenListPage({super.key, this.wallet});

  @override
  void onBlocCreated(BuildContext context, TokenListBloc bloc) {
    bloc.updateWalletAddress(wallet?.address ?? '');
  }

  @override
  Widget buildItem(BuildContext context, TokenUiModel item, int index) {
    return TokenItemView(
      token: item,
      isFirst: index == 0,
      onTap: () {
        // TODO: Navigate to token detail
      },
    );
  }
}
