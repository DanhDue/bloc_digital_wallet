// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// Transaction States
/// ============================================================================
/// States represent the UI state at any given moment.
///
/// HOW TO EXTEND:
/// 1. Add new state classes for different UI states (e.g., Loading, Success, Error)
/// 2. Each state should extend TransactionState
/// 3. Include relevant data in each state class
///
/// EXAMPLE - Adding Loading and Success states:
/// ```dart
/// class TransactionLoading extends TransactionState {
///   const TransactionLoading();
///   @override
///   List<Object?> get props => [];
/// }
///
/// class TransactionSuccess extends TransactionState {
///   final List<YourEntity> items;
///   const TransactionSuccess(this.items);
///   @override
///   List<Object?> get props => [items];
/// }
/// ```
/// ============================================================================

sealed class TransactionState extends BaseState with EquatableMixin {
  const TransactionState();
}

/// Initial state - the starting point
class TransactionInitial extends TransactionState {
  const TransactionInitial();

  @override
  List<Object?> get props => [];
}
