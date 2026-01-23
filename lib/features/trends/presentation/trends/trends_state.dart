// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// Trends States
/// ============================================================================
/// States represent the UI state at any given moment.
///
/// HOW TO EXTEND:
/// 1. Add new state classes for different UI states (e.g., Loading, Success, Error)
/// 2. Each state should extend TrendsState
/// 3. Include relevant data in each state class
///
/// EXAMPLE - Adding Loading and Success states:
/// ```dart
/// class TrendsLoading extends TrendsState {
///   const TrendsLoading();
///   @override
///   List<Object?> get props => [];
/// }
///
/// class TrendsSuccess extends TrendsState {
///   final List<YourEntity> items;
///   const TrendsSuccess(this.items);
///   @override
///   List<Object?> get props => [items];
/// }
/// ```
/// ============================================================================

sealed class TrendsState extends BaseState with EquatableMixin {
  const TrendsState();
}

/// Initial state - the starting point
class TrendsInitial extends TrendsState {
  const TrendsInitial();

  @override
  List<Object?> get props => [];
}
