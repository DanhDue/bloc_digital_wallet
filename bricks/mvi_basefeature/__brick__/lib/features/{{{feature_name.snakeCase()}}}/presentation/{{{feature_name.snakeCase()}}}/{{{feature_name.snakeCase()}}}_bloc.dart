// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when adding action handlers
// import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/architecture/architecture.dart';
import '{{{feature_name.snakeCase()}}}_action.dart';
import '{{{feature_name.snakeCase()}}}_state.dart';
import '{{{feature_name.snakeCase()}}}_event.dart';

/// ============================================================================
/// {{feature_name.pascalCase()}} BLoC
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
/// class {{feature_name.pascalCase()}}Bloc extends MviBloc<...> {
///   final Get{{feature_name.pascalCase()}}UseCase _get{{feature_name.pascalCase()}}UseCase;
/// 
///   {{feature_name.pascalCase()}}Bloc(this._get{{feature_name.pascalCase()}}UseCase)
///       : super(const {{feature_name.pascalCase()}}Initial()) {
///     handleActionDroppable<Load{{feature_name.pascalCase()}}Action>(_onLoad);
///   }
/// 
///   Future<void> _onLoad(
///     Load{{feature_name.pascalCase()}}Action action,
///     Emitter<{{feature_name.pascalCase()}}State> emit,
///   ) async {
///     emit(const {{feature_name.pascalCase()}}Loading());
///     final result = await _get{{feature_name.pascalCase()}}UseCase();
///     result.fold(
///       (failure) => emit({{feature_name.pascalCase()}}Error(failure.message)),
///       (data) => emit({{feature_name.pascalCase()}}Success(data)),
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
class {{feature_name.pascalCase()}}Bloc extends MviBloc<
  {{feature_name.pascalCase()}}Action,
  {{feature_name.pascalCase()}}State,
  {{feature_name.pascalCase()}}Event
> {
  {{feature_name.pascalCase()}}Bloc() : super(const {{feature_name.pascalCase()}}Initial()) {
    // TODO: Register action handlers here
    // handleActionDroppable<Init{{feature_name.pascalCase()}}Action>(_onInit);
  }

  @override
  void onAction({{feature_name.pascalCase()}}Action action) {
    add(action);
  }

  // TODO: Implement action handlers
  // Future<void> _onInit(
  //   Init{{feature_name.pascalCase()}}Action action,
  //   Emitter<{{feature_name.pascalCase()}}State> emit,
  // ) async {
  //   // Handle initialization
  // }
}
