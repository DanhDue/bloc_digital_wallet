// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:transaction/presentation/transaction/transaction_page.dart';

part 'transaction_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class TransactionRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: TransactionRoute.page, path: TransactionRoutes.transaction),
  ];
}

class TransactionRoutes {
  static const String transaction = '/transaction';
}
