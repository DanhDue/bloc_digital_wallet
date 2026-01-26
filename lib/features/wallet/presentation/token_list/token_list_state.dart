// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// TokenList States
/// ============================================================================
/// States represent the UI state at any given moment.
///
/// HOW TO EXTEND:
/// 1. Add new state classes for different UI states (e.g., Loading, Success, Error)
/// 2. Each state should extend TokenListState
/// 3. Include relevant data in each state class
///
/// EXAMPLE - Adding Loading and Success states:
/// ```dart
/// class TokenListLoading extends TokenListState {
///   const TokenListLoading();
///   @override
///   List<Object?> get props => [];
/// }
///
/// class TokenListSuccess extends TokenListState {
///   final List<YourEntity> items;
///   const TokenListSuccess(this.items);
///   @override
///   List<Object?> get props => [items];
/// }
/// ```
/// ============================================================================

sealed class TokenListState extends BaseState with EquatableMixin {
  const TokenListState();
}

/// Initial state - the starting point
class TokenListInitial extends TokenListState {
  const TokenListInitial();

  @override
  List<Object?> get props => [];
}
