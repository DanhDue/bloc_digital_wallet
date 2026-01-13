// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/usecases/get_{{{feature_name.snakeCase()}}}_usecase.dart';
import '{{{feature_name.snakeCase()}}}_action.dart';
import '{{{feature_name.snakeCase()}}}_state.dart';
import '{{{feature_name.snakeCase()}}}_event.dart';

@injectable
class {{feature_name.pascalCase()}}Bloc extends MviBloc<
  {{feature_name.pascalCase()}}Action,
  {{feature_name.pascalCase()}}State,
  {{feature_name.pascalCase()}}Event
> {
  final Get{{feature_name.pascalCase()}}UseCase _get{{feature_name.pascalCase()}}UseCase;

  {{feature_name.pascalCase()}}Bloc(this._get{{feature_name.pascalCase()}}UseCase)
      : super(const {{feature_name.pascalCase()}}Initial()) {
    handleAction(null, _onLoad{{feature_name.pascalCase()}});
  }

  @override
  void onAction({{feature_name.pascalCase()}}Action action) {
    add(action);
  }

  Future<void> _onLoad{{feature_name.pascalCase()}}(
    Load{{feature_name.pascalCase()}}Action action,
    Emitter<{{feature_name.pascalCase()}}State> emit,
  ) async {
    emit(const {{feature_name.pascalCase()}}Loading());

    final result = await _get{{feature_name.pascalCase()}}UseCase();

    result.fold(
      (failure) {
        emit({{feature_name.pascalCase()}}Error(failure.message));
        emitEvent(ShowMessage.error(failure.message));
      },
      (items) => emit({{feature_name.pascalCase()}}sLoaded(items)),
    );
  }
}
