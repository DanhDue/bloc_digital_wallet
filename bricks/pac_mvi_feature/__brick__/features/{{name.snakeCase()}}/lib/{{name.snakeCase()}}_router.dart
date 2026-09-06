// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:{{name.snakeCase()}}/presentation/{{name.snakeCase()}}/{{name.snakeCase()}}_page.dart';

part '{{name.snakeCase()}}_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class {{name.pascalCase()}}Router extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: {{name.pascalCase()}}Route.page,
      path: {{name.pascalCase()}}Routes.{{name.camelCase()}},
    ),
  ];
}

class {{name.pascalCase()}}Routes {
  static const String {{name.camelCase()}} = '/{{name.snakeCase()}}';
}
