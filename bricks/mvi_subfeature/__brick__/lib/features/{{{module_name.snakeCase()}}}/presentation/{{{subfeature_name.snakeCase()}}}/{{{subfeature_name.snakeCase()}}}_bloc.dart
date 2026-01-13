// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/architecture/architecture.dart';
import '../../domain/usecases/get_{{{subfeature_name.snakeCase()}}}_usecase.dart';
import '{{{subfeature_name.snakeCase()}}}_action.dart';
import '{{{subfeature_name.snakeCase()}}}_event.dart';
import '{{{subfeature_name.snakeCase()}}}_state.dart';

@injectable
class {{subfeature_name.pascalCase()}}Bloc
    extends MviBloc<{{subfeature_name.pascalCase()}}Action, {{subfeature_name.pascalCase()}}State, {{subfeature_name.pascalCase()}}Event> {
  final Get{{subfeature_name.pascalCase()}}UseCase _get{{subfeature_name.pascalCase()}}UseCase;

  {{subfeature_name.pascalCase()}}Bloc(this._get{{subfeature_name.pascalCase()}}UseCase)
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

    final result = await _get{{subfeature_name.pascalCase()}}UseCase();

    result.fold(
      (failure) {
        emit({{subfeature_name.pascalCase()}}Error(failure.message));
        emitEvent(ShowMessage.error(failure.message));
      },
      (items) => emit({{subfeature_name.pascalCase()}}Success(items)),
    );
  }
}
