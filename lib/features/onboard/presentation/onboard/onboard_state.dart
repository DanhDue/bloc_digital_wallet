// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// Onboard States
/// ============================================================================
/// States represent the UI state at any given moment.
///
/// HOW TO EXTEND:
/// 1. Add new state classes for different UI states (e.g., Loading, Success, Error)
/// 2. Each state should extend OnboardState
/// 3. Include relevant data in each state class
///
/// EXAMPLE - Adding Loading and Success states:
/// ```dart
/// class OnboardLoading extends OnboardState {
///   const OnboardLoading();
///   @override
///   List<Object?> get props => [];
/// }
///
/// class OnboardSuccess extends OnboardState {
///   final List<YourEntity> items;
///   const OnboardSuccess(this.items);
///   @override
///   List<Object?> get props => [items];
/// }
/// ```
/// ============================================================================

sealed class OnboardState extends BaseState with EquatableMixin {
  const OnboardState();
}

/// Initial state - the starting point
class OnboardInitial extends OnboardState {
  const OnboardInitial();

  @override
  List<Object?> get props => [];
}
