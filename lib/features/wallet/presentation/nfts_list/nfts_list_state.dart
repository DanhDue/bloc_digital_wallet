// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// NftsList States
/// ============================================================================
/// States represent the UI state at any given moment.
///
/// HOW TO EXTEND:
/// 1. Add new state classes for different UI states (e.g., Loading, Success, Error)
/// 2. Each state should extend NftsListState
/// 3. Include relevant data in each state class
///
/// EXAMPLE - Adding Loading and Success states:
/// ```dart
/// class NftsListLoading extends NftsListState {
///   const NftsListLoading();
///   @override
///   List<Object?> get props => [];
/// }
///
/// class NftsListSuccess extends NftsListState {
///   final List<YourEntity> items;
///   const NftsListSuccess(this.items);
///   @override
///   List<Object?> get props => [items];
/// }
/// ```
/// ============================================================================

sealed class NftsListState extends BaseState with EquatableMixin {
  const NftsListState();
}

/// Initial state - the starting point
class NftsListInitial extends NftsListState {
  const NftsListInitial();

  @override
  List<Object?> get props => [];
}
