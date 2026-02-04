// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:framework/framework.dart';
import 'package:flutter/material.dart';

import '{{subfeature_name.snakeCase()}}_action.dart';
import '{{subfeature_name.snakeCase()}}_bloc.dart';
import '{{subfeature_name.snakeCase()}}_event.dart';
import '{{subfeature_name.snakeCase()}}_state.dart';

@RoutePage()
class {{subfeature_name.pascalCase()}}Page extends BaseMviPage<{{subfeature_name.pascalCase()}}Bloc, {{subfeature_name.pascalCase()}}State, {{subfeature_name.pascalCase()}}Event> {
  const {{subfeature_name.pascalCase()}}Page({super.key});

  @override
  BaseAction? get initialAction => const {{subfeature_name.pascalCase()}}Action.started();

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(title: const Text('{{subfeature_name.titleCase()}}'));
  }

  @override
  Widget handleState(BuildContext context, {{subfeature_name.pascalCase()}}State state) {
    return switch (state.status) {
      {{subfeature_name.pascalCase()}}Status.initial => const Center(child: Text('Initial')),
      {{subfeature_name.pascalCase()}}Status.loading => const Center(child: CircularProgressIndicator()),
      {{subfeature_name.pascalCase()}}Status.success => _buildContent(context, state),
      {{subfeature_name.pascalCase()}}Status.failure => Center(child: Text(state.errorMessage ?? 'Error')),
    };
  }

  @override
  void handleEvent(BuildContext context, {{subfeature_name.pascalCase()}}Event event) {
    event.when(
      initial: () {},
    );
  }

  Widget _buildContent(BuildContext context, {{subfeature_name.pascalCase()}}State state) {
    return Center(
      child: Text('{{subfeature_name.titleCase()}} Subfeature'),
    );
  }
}
