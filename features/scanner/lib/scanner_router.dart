// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:scanner/presentation/scanner/scanner_page.dart';

part 'scanner_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class ScannerRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [AutoRoute(page: ScannerRoute.page, path: ScannerRoutes.scanner)];
}

class ScannerRoutes {
  static const String scanner = '/scanner';
}
