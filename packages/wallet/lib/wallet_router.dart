// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wallet/domain/entities/wallet_entity.dart';
import 'package:wallet/presentation/nfts_list/nfts_list_page.dart';
import 'package:wallet/presentation/network_selection/network_selection_page.dart';
import 'package:wallet/presentation/token_list/token_list_page.dart';
import 'package:wallet/presentation/wallet/wallet_page.dart';
import 'package:wallet/presentation/wallet_list/wallet_list_page.dart';

part 'wallet_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class WalletRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: WalletListRoute.page, path: WalletRoutes.walletList),
    AutoRoute(page: TokenListRoute.page, path: WalletRoutes.tokenList),
    AutoRoute(page: NftsListRoute.page, path: WalletRoutes.nftsList),
    AutoRoute(page: NetworkSelectionRoute.page, path: WalletRoutes.networkSelection),
    AutoRoute(page: WalletRoute.page, path: WalletRoutes.wallet),
  ];
}

class WalletRoutes {
  static const String walletList = '$wallet/wallet_list';
  static const String tokenList = '$wallet/token_list';
  static const String nftsList = '$wallet/nfts_list';
  static const String networkSelection = '$wallet/network_selection';
  static const String wallet = '/wallet';
}
