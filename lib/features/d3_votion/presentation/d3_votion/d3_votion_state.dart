// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// D3Votion States
/// ============================================================================
/// States represent the UI state at any given moment.
///
/// HOW TO EXTEND:
/// 1. Add new state classes for different UI states (e.g., Loading, Success, Error)
/// 2. Each state should extend D3VotionState
/// 3. Include relevant data in each state class
///
/// EXAMPLE - Adding Loading and Success states:
/// ```dart
/// class D3VotionLoading extends D3VotionState {
///   const D3VotionLoading();
///   @override
///   List<Object?> get props => [];
/// }
///
/// class D3VotionSuccess extends D3VotionState {
///   final List<YourEntity> items;
///   const D3VotionSuccess(this.items);
///   @override
///   List<Object?> get props => [items];
/// }
/// ```
/// ============================================================================

sealed class D3VotionState extends BaseState with EquatableMixin {
  const D3VotionState();
}

/// Initial state - the starting point
class D3VotionInitial extends D3VotionState {
  const D3VotionInitial();

  @override
  List<Object?> get props => [];
}
