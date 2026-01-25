// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// NetworkSelection States
/// ============================================================================
/// States represent the UI state at any given moment.
///
/// HOW TO EXTEND:
/// 1. Add new state classes for different UI states (e.g., Loading, Success, Error)
/// 2. Each state should extend NetworkSelectionState
/// 3. Include relevant data in each state class
///
/// EXAMPLE - Adding Loading and Success states:
/// ```dart
/// class NetworkSelectionLoading extends NetworkSelectionState {
///   const NetworkSelectionLoading();
///   @override
///   List<Object?> get props => [];
/// }
///
/// class NetworkSelectionSuccess extends NetworkSelectionState {
///   final List<YourEntity> items;
///   const NetworkSelectionSuccess(this.items);
///   @override
///   List<Object?> get props => [items];
/// }
/// ```
/// ============================================================================

sealed class NetworkSelectionState extends BaseState with EquatableMixin {
  const NetworkSelectionState();
}

/// Initial state - the starting point
class NetworkSelectionInitial extends NetworkSelectionState {
  const NetworkSelectionInitial();

  @override
  List<Object?> get props => [];
}
