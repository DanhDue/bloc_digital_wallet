// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:framework/framework.dart';
import 'package:flutter/material.dart';

import '{{name.snakeCase()}}_bloc.dart';
import '{{name.snakeCase()}}_event.dart';
import '{{name.snakeCase()}}_state.dart';

@RoutePage()
class {{name.pascalCase()}}Page
    extends BaseMviPage<{{name.pascalCase()}}Bloc, {{name.pascalCase()}}State, {{name.pascalCase()}}Event> {
  const {{name.pascalCase()}}Page({super.key});

  @override
  Widget handleState(BuildContext context, {{name.pascalCase()}}State state) {
    return Scaffold(
      appBar: AppBar(title: const Text('{{name.pascalCase()}}')),
      body: const Center(child: Text('{{name.pascalCase()}} Feature')),
    );
  }

  @override
  void handleEvent(BuildContext context, {{name.pascalCase()}}Event event) {
    // TODO: Handle side-effect events (navigation, toasts, etc.)
  }
}
