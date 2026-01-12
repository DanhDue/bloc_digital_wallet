// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/usecases/get_{{{feature_name.snakeCase()}}}_usecase.dart';
import '../../domain/usecases/get_all_{{{feature_name.snakeCase()}}}s_usecase.dart';
import '{{{feature_name.snakeCase()}}}_action.dart';
import '{{{feature_name.snakeCase()}}}_state.dart';
import '{{{feature_name.snakeCase()}}}_event.dart';

@injectable
class {{feature_name.pascalCase()}}Bloc extends MviBloc<
  {{feature_name.pascalCase()}}Action,
  {{feature_name.pascalCase()}}State,
  {{feature_name.pascalCase()}}Event
> {
  final Get{{feature_name.pascalCase()}}UseCase get{{feature_name.pascalCase()}}UseCase;
  final GetAll{{feature_name.pascalCase()}}sUseCase getAll{{feature_name.pascalCase()}}sUseCase;

  {{feature_name.pascalCase()}}Bloc({
    required this.get{{feature_name.pascalCase()}}UseCase,
    required this.getAll{{feature_name.pascalCase()}}sUseCase,
  }) : super(const {{feature_name.pascalCase()}}Initial()) {
    // Register action handlers
    handleAction(null, _onLoadAll{{feature_name.pascalCase()}}s);
    handleAction(null, _onLoad{{feature_name.pascalCase()}});
    handleAction(null, _onCreate{{feature_name.pascalCase()}});
    handleAction(null, _onUpdate{{feature_name.pascalCase()}});
    handleAction(null, _onDelete{{feature_name.pascalCase()}});
    handleAction(null, _onRefresh{{feature_name.pascalCase()}}s);
  }

  /// Single entry point for all actions (Following Android pattern)
  /// This is the ONLY method View should call
  @override
  void onAction({{feature_name.pascalCase()}}Action action) {
    add(action);
  }

  Future<void> _onLoadAll{{feature_name.pascalCase()}}s(
    LoadAll{{feature_name.pascalCase()}}sAction action,
    Emitter<{{feature_name.pascalCase()}}State> emit,
  ) async {
    emit(const {{feature_name.pascalCase()}}Loading());
    
    final result = await getAll{{feature_name.pascalCase()}}sUseCase();
    
    result.fold(
      (failure) {
        emit({{feature_name.pascalCase()}}Error(failure.message));
        emitEvent(ShowErrorMessage(failure.message));
      },
      (items) {
        if (items.isEmpty) {
          emit(const {{feature_name.pascalCase()}}Empty());
        } else {
          emit({{feature_name.pascalCase()}}sLoaded(items));
        }
      },
    );
  }

  Future<void> _onLoad{{feature_name.pascalCase()}}(
    Load{{feature_name.pascalCase()}}Action action,
    Emitter<{{feature_name.pascalCase()}}State> emit,
  ) async {
    emit(const {{feature_name.pascalCase()}}Loading());
    
    final result = await get{{feature_name.pascalCase()}}UseCase(action.id);
    
    result.fold(
      (failure) {
        emit({{feature_name.pascalCase()}}Error(failure.message));
        emitEvent(ShowErrorMessage(failure.message));
      },
      (item) => emit({{feature_name.pascalCase()}}Loaded(item)),
    );
  }

  Future<void> _onCreate{{feature_name.pascalCase()}}(
    Create{{feature_name.pascalCase()}}Action action,
    Emitter<{{feature_name.pascalCase()}}State> emit,
  ) async {
    // TODO: Implement create logic
    emitEvent(const ShowSuccessMessage('Created successfully'));
  }

  Future<void> _onUpdate{{feature_name.pascalCase()}}(
    Update{{feature_name.pascalCase()}}Action action,
    Emitter<{{feature_name.pascalCase()}}State> emit,
  ) async {
    // TODO: Implement update logic
    emitEvent(const ShowSuccessMessage('Updated successfully'));
  }

  Future<void> _onDelete{{feature_name.pascalCase()}}(
    Delete{{feature_name.pascalCase()}}Action action,
    Emitter<{{feature_name.pascalCase()}}State> emit,
  ) async {
    // TODO: Implement delete logic
    emitEvent(const ShowSuccessMessage('Deleted successfully'));
  }

  Future<void> _onRefresh{{feature_name.pascalCase()}}s(
    Refresh{{feature_name.pascalCase()}}sAction action,
    Emitter<{{feature_name.pascalCase()}}State> emit,
  ) async {
    // Reload all items
    add(const LoadAll{{feature_name.pascalCase()}}sAction());
  }
}
