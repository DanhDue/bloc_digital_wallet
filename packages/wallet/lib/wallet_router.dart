// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:wallet/presentation/wallet/wallet_page.dart';

part 'wallet_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class WalletRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: WalletRoute.page,
      path: WalletRoutes.wallet,
    ),
  ];
}

class WalletRoutes {
  static const String wallet = '/wallet';
}
