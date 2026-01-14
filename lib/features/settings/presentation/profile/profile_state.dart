// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// Profile States
/// ============================================================================
/// States represent the UI state at any given moment.
///
/// HOW TO EXTEND:
/// 1. Add new state classes for different UI states (e.g., Loading, Success, Error)
/// 2. Each state should extend ProfileState
/// 3. Include relevant data in each state class
///
/// EXAMPLE - Adding Loading and Success states:
/// ```dart
/// class ProfileLoading extends ProfileState {
///   const ProfileLoading();
///   @override
///   List<Object?> get props => [];
/// }
///
/// class ProfileSuccess extends ProfileState {
///   final List<YourEntity> items;
///   const ProfileSuccess(this.items);
///   @override
///   List<Object?> get props => [items];
/// }
/// ```
/// ============================================================================

sealed class ProfileState extends BaseState with EquatableMixin {
  const ProfileState();
}

/// Initial state - the starting point
class ProfileInitial extends ProfileState {
  const ProfileInitial();

  @override
  List<Object?> get props => [];
}
