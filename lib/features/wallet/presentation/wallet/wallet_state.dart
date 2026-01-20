// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// Wallet States
/// ============================================================================
/// States represent the UI state at any given moment.
///
/// HOW TO EXTEND:
/// 1. Add new state classes for different UI states (e.g., Loading, Success, Error)
/// 2. Each state should extend WalletState
/// 3. Include relevant data in each state class
///
/// EXAMPLE - Adding Loading and Success states:
/// ```dart
/// class WalletLoading extends WalletState {
///   const WalletLoading();
///   @override
///   List<Object?> get props => [];
/// }
///
/// class WalletSuccess extends WalletState {
///   final List<YourEntity> items;
///   const WalletSuccess(this.items);
///   @override
///   List<Object?> get props => [items];
/// }
/// ```
/// ============================================================================

sealed class WalletState extends BaseState with EquatableMixin {
  const WalletState();
}

/// Initial state - the starting point
class WalletInitial extends WalletState {
  const WalletInitial();

  @override
  List<Object?> get props => [];
}
