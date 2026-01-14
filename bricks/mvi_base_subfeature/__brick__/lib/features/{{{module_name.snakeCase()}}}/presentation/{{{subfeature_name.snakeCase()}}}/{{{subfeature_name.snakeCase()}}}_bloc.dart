// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when adding action handlers
// import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/architecture/architecture.dart';
import '{{{subfeature_name.snakeCase()}}}_action.dart';
import '{{{subfeature_name.snakeCase()}}}_state.dart';
import '{{{subfeature_name.snakeCase()}}}_event.dart';

/// ============================================================================
/// {{subfeature_name.pascalCase()}} BLoC
/// ============================================================================
/// The BLoC processes Actions and emits States/Events.
/// 
/// HOW TO EXTEND:
/// 1. Add use case dependencies via constructor injection
/// 2. Register action handlers in constructor using handleAction methods
/// 3. Implement handler methods that emit new states/events
/// 
/// EXAMPLE - Adding use case and handler:
/// ```dart
/// @injectable
/// class {{subfeature_name.pascalCase()}}Bloc extends MviBloc<...> {
///   final Get{{subfeature_name.pascalCase()}}UseCase _get{{subfeature_name.pascalCase()}}UseCase;
/// 
///   {{subfeature_name.pascalCase()}}Bloc(this._get{{subfeature_name.pascalCase()}}UseCase)
///       : super(const {{subfeature_name.pascalCase()}}Initial()) {
///     handleActionDroppable<Load{{subfeature_name.pascalCase()}}Action>(_onLoad);
///   }
/// 
///   Future<void> _onLoad(
///     Load{{subfeature_name.pascalCase()}}Action action,
///     Emitter<{{subfeature_name.pascalCase()}}State> emit,
///   ) async {
///     emit(const {{subfeature_name.pascalCase()}}Loading());
///     final result = await _get{{subfeature_name.pascalCase()}}UseCase();
///     result.fold(
///       (failure) => emit({{subfeature_name.pascalCase()}}Error(failure.message)),
///       (data) => emit({{subfeature_name.pascalCase()}}Success(data)),
///     );
///   }
/// }
/// ```
/// 
/// ACTION HANDLER TYPES:
/// - handleActionDroppable: Drops new actions while processing (default)
/// - handleActionSequential: Queues actions, processes one at a time
/// - handleActionConcurrent: Processes actions concurrently
/// ============================================================================

@injectable
class {{subfeature_name.pascalCase()}}Bloc extends MviBloc<
  {{subfeature_name.pascalCase()}}Action,
  {{subfeature_name.pascalCase()}}State,
  {{subfeature_name.pascalCase()}}Event
> {
  {{subfeature_name.pascalCase()}}Bloc() : super(const {{subfeature_name.pascalCase()}}Initial()) {
    // TODO: Register action handlers here
    // handleActionDroppable<Load{{subfeature_name.pascalCase()}}Action>(_onLoad);
  }

  @override
  void onAction({{subfeature_name.pascalCase()}}Action action) {
    add(action);
  }

  // TODO: Implement action handlers
  // Future<void> _onLoad(
  //   Load{{subfeature_name.pascalCase()}}Action action,
  //   Emitter<{{subfeature_name.pascalCase()}}State> emit,
  // ) async {
  //   // Handle loading
  // }
}
