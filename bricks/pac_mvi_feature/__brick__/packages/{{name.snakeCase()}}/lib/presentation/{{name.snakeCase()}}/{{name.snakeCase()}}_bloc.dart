// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:framework/framework.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:{{name.snakeCase()}}/domain/usecases/get_{{name.snakeCase()}}_usecase.dart';
import 'package:{{name.snakeCase()}}/presentation/{{name.snakeCase()}}/models/{{name.snakeCase()}}_ui_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '{{name.snakeCase()}}_action.dart';
import '{{name.snakeCase()}}_event.dart';
import '{{name.snakeCase()}}_state.dart';

@injectable
class {{name.pascalCase()}}Bloc extends MviBloc<{{name.pascalCase()}}Action, {{name.pascalCase()}}State, {{name.pascalCase()}}Event> {
  final Get{{name.pascalCase()}}UseCase _get{{name.pascalCase()}}UseCase;

  {{name.pascalCase()}}Bloc(this._get{{name.pascalCase()}}UseCase) : super(const {{name.pascalCase()}}State()) {
    on<{{name.pascalCase()}}Action>((action, emit) {
      action.when(
        started: () => _onStarted(emit),
      );
    });
  }

  Future<void> _onStarted(Emitter<{{name.pascalCase()}}State> emit) async {
    emit(state.copyWith(status: {{name.pascalCase()}}Status.loading));
    final result = await _get{{name.pascalCase()}}UseCase();
    result.fold(
      (failure) {
        emit(state.copyWith(status: {{name.pascalCase()}}Status.failure, errorMessage: failure.message));
        emitEvent(const {{name.pascalCase()}}Event.initial());
      },
      (entity) {
        final uiModel = {{name.pascalCase()}}UiModel.fromEntity(entity);
        emit(state.copyWith(status: {{name.pascalCase()}}Status.success, uiModel: uiModel));
      },
    );
  }
}
