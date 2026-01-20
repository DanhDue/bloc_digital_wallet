// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// Start States
/// ============================================================================
/// States represent the UI state at any given moment.
///
/// HOW TO EXTEND:
/// 1. Add new state classes for different UI states (e.g., Loading, Success, Error)
/// 2. Each state should extend StartState
/// 3. Include relevant data in each state class
///
/// EXAMPLE - Adding Loading and Success states:
/// ```dart
/// class StartLoading extends StartState {
///   const StartLoading();
///   @override
///   List<Object?> get props => [];
/// }
///
/// class StartSuccess extends StartState {
///   final List<YourEntity> items;
///   const StartSuccess(this.items);
///   @override
///   List<Object?> get props => [items];
/// }
/// ```
/// ============================================================================

sealed class StartState extends BaseState with EquatableMixin {
  const StartState();
}

/// Initial state - the starting point
class StartInitial extends StartState {
  const StartInitial();

  @override
  List<Object?> get props => [];
}
