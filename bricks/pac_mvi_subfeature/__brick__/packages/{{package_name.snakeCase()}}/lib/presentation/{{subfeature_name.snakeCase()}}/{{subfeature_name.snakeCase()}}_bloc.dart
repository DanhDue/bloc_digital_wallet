// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:framework/framework.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:{{package_name.snakeCase()}}/presentation/{{subfeature_name.snakeCase()}}/{{subfeature_name.snakeCase()}}_action.dart';
import 'package:{{package_name.snakeCase()}}/presentation/{{subfeature_name.snakeCase()}}/{{subfeature_name.snakeCase()}}_event.dart';
import 'package:{{package_name.snakeCase()}}/presentation/{{subfeature_name.snakeCase()}}/{{subfeature_name.snakeCase()}}_state.dart';

@injectable
class {{subfeature_name.pascalCase()}}Bloc extends MviBloc<{{subfeature_name.pascalCase()}}Action, {{subfeature_name.pascalCase()}}State, {{subfeature_name.pascalCase()}}Event> {
  {{subfeature_name.pascalCase()}}Bloc() : super(const {{subfeature_name.pascalCase()}}State()) {
    on<{{subfeature_name.pascalCase()}}Action>(_onAction);
  }

  Future<void> _onAction(
    {{subfeature_name.pascalCase()}}Action action,
    Emitter<{{subfeature_name.pascalCase()}}State> emit,
  ) async {
    await action.when(
      started: () async {
        emit(state.copyWith(status: {{subfeature_name.pascalCase()}}Status.loading));
        // TODO: Add logic here
        emit(state.copyWith(status: {{subfeature_name.pascalCase()}}Status.success));
      },
    );
  }
}
