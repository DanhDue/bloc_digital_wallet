// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// {{feature_name.pascalCase()}} States
/// ============================================================================
/// States represent the UI state at any given moment.
/// 
/// HOW TO EXTEND:
/// 1. Add new state classes for different UI states (e.g., Loading, Success, Error)
/// 2. Each state should extend {{feature_name.pascalCase()}}State
/// 3. Include relevant data in each state class
/// 
/// EXAMPLE - Adding Loading and Success states:
/// ```dart
/// class {{feature_name.pascalCase()}}Loading extends {{feature_name.pascalCase()}}State {
///   const {{feature_name.pascalCase()}}Loading();
///   @override
///   List<Object?> get props => [];
/// }
/// 
/// class {{feature_name.pascalCase()}}Success extends {{feature_name.pascalCase()}}State {
///   final List<YourEntity> items;
///   const {{feature_name.pascalCase()}}Success(this.items);
///   @override
///   List<Object?> get props => [items];
/// }
/// ```
/// ============================================================================

sealed class {{feature_name.pascalCase()}}State extends BaseState with EquatableMixin {
  const {{feature_name.pascalCase()}}State();
}

/// Initial state - the starting point
class {{feature_name.pascalCase()}}Initial extends {{feature_name.pascalCase()}}State {
  const {{feature_name.pascalCase()}}Initial();

  @override
  List<Object?> get props => [];
}
