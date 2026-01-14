// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// Dashboard States
/// ============================================================================
/// States represent the UI state at any given moment.
///
/// HOW TO EXTEND:
/// 1. Add new state classes for different UI states (e.g., Loading, Success, Error)
/// 2. Each state should extend DashboardState
/// 3. Include relevant data in each state class
///
/// EXAMPLE - Adding Loading and Success states:
/// ```dart
/// class DashboardLoading extends DashboardState {
///   const DashboardLoading();
///   @override
///   List<Object?> get props => [];
/// }
///
/// class DashboardSuccess extends DashboardState {
///   final List<YourEntity> items;
///   const DashboardSuccess(this.items);
///   @override
///   List<Object?> get props => [items];
/// }
/// ```
/// ============================================================================

sealed class DashboardState extends BaseState with EquatableMixin {
  const DashboardState();
}

/// Initial state - the starting point
class DashboardInitial extends DashboardState {
  const DashboardInitial();

  @override
  List<Object?> get props => [];
}
