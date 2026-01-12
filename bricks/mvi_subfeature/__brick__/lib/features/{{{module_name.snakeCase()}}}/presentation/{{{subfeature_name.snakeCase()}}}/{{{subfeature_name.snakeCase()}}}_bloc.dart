// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/architecture/architecture.dart';
import '../../domain/usecases/{{{subfeature_name.snakeCase()}}}_usecase.dart';
import '{{{subfeature_name.snakeCase()}}}_action.dart';
import '{{{subfeature_name.snakeCase()}}}_event.dart';
import '{{{subfeature_name.snakeCase()}}}_state.dart';

@injectable
class {{subfeature_name.pascalCase()}}Bloc
    extends MviBloc<{{subfeature_name.pascalCase()}}Action, {{subfeature_name.pascalCase()}}State, {{subfeature_name.pascalCase()}}Event> {
  final {{subfeature_name.pascalCase()}}UseCase _{{subfeature_name.camelCase()}}UseCase;

  {{subfeature_name.pascalCase()}}Bloc(this._{{subfeature_name.camelCase()}}UseCase)
      : super(const {{subfeature_name.pascalCase()}}Initial()) {
    handleActionDroppable<Load{{subfeature_name.pascalCase()}}Action>(_onLoad{{subfeature_name.pascalCase()}});
  }

  @override
  void onAction({{subfeature_name.pascalCase()}}Action action) {
    add(action);
  }

  Future<void> _onLoad{{subfeature_name.pascalCase()}}(
    Load{{subfeature_name.pascalCase()}}Action action,
    Emitter<{{subfeature_name.pascalCase()}}State> emit,
  ) async {
    emit(const {{subfeature_name.pascalCase()}}Loading());

    final result = await _{{subfeature_name.camelCase()}}UseCase();

    result.fold(
      (failure) {
        emit({{subfeature_name.pascalCase()}}Error(failure.message));
        emitEvent(Show{{subfeature_name.pascalCase()}}ErrorMessage(failure.message));
      },
      (data) {
        {{#needs_entity}}emit({{subfeature_name.pascalCase()}}Success(data));{{/needs_entity}}
        {{^needs_entity}}emit(const {{subfeature_name.pascalCase()}}Success());{{/needs_entity}}
        emitEvent(const Show{{subfeature_name.pascalCase()}}SuccessMessage('Success'));
      },
    );
  }
}
