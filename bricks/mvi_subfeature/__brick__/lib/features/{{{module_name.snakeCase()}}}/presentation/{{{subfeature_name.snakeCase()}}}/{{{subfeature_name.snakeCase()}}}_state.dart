// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// {{subfeature_name.pascalCase()}} States
/// ============================================================================
/// States represent the UI state at any given moment.
/// 
/// HOW TO EXTEND:
/// 1. Add new state classes for different UI states (e.g., Loading, Success, Error)
/// 2. Each state should extend {{subfeature_name.pascalCase()}}State
/// 3. Include relevant data in each state class
/// 
/// EXAMPLE - Adding Loading and Success states:
/// ```dart
/// class {{subfeature_name.pascalCase()}}Loading extends {{subfeature_name.pascalCase()}}State {
///   const {{subfeature_name.pascalCase()}}Loading();
///   @override
///   List<Object?> get props => [];
/// }
/// 
/// class {{subfeature_name.pascalCase()}}Success extends {{subfeature_name.pascalCase()}}State {
///   final List<YourEntity> items;
///   const {{subfeature_name.pascalCase()}}Success(this.items);
///   @override
///   List<Object?> get props => [items];
/// }
/// ```
/// ============================================================================

sealed class {{subfeature_name.pascalCase()}}State extends BaseState with EquatableMixin {
  const {{subfeature_name.pascalCase()}}State();
}

/// Initial state - the starting point
class {{subfeature_name.pascalCase()}}Initial extends {{subfeature_name.pascalCase()}}State {
  const {{subfeature_name.pascalCase()}}Initial();

  @override
  List<Object?> get props => [];
}
