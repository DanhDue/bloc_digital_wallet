// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/entities/wallet_entity.dart';

/// States for Wallet feature
sealed class WalletState extends BaseState with EquatableMixin {
  const WalletState();
}

/// Initial state
class WalletInitial extends WalletState {
  const WalletInitial();

  @override
  List<Object?> get props => [];
}

/// Loading state
class WalletLoading extends WalletState {
  const WalletLoading();

  @override
  List<Object?> get props => [];
}

/// Loaded state with list
class WalletsLoaded extends WalletState {
  final List<WalletEntity> items;

  const WalletsLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

/// Loaded state with single item
class WalletLoaded extends WalletState {
  final WalletEntity item;

  const WalletLoaded(this.item);

  @override
  List<Object?> get props => [item];
}

/// Error state
class WalletError extends WalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Empty state
class WalletEmpty extends WalletState {
  const WalletEmpty();

  @override
  List<Object?> get props => [];
}
