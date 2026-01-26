// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/entities/wallet_entity.dart';

/// ============================================================================
/// WalletList States
/// ============================================================================
/// States represent the UI state at any given moment.
///
/// HOW TO EXTEND:
/// 1. Add new state classes for different UI states (e.g., Loading, Success, Error)
/// 2. Each state should extend WalletListState
/// 3. Include relevant data in each state class
///
/// EXAMPLE - Adding Loading and Success states:
/// ```dart
/// class WalletListLoading extends WalletListState {
///   const WalletListLoading();
///   @override
///   List<Object?> get props => [];
/// }
///
/// class WalletListSuccess extends WalletListState {
///   final List<YourEntity> items;
///   const WalletListSuccess(this.items);
///   @override
///   List<Object?> get props => [items];
/// }
/// ```
/// ============================================================================

sealed class WalletListState extends BaseState with EquatableMixin {
  const WalletListState();
}

/// Initial state - the starting point
class WalletListInitial extends WalletListState {
  const WalletListInitial();

  @override
  List<Object?> get props => [];
}

/// Loading state
class WalletListLoading extends WalletListState {
  const WalletListLoading();
  @override
  List<Object?> get props => [];
}

/// Success state with data
class WalletListSuccess extends WalletListState {
  final List<WalletEntity> wallets;
  const WalletListSuccess(this.wallets);

  @override
  List<Object?> get props => [wallets];
}

/// Error state
class WalletListError extends WalletListState {
  final String message;
  const WalletListError(this.message);

  @override
  List<Object?> get props => [message];
}
