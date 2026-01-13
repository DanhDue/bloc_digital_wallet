// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/entities/scanner_entity.dart';

/// States for Scanner feature
sealed class ScannerState extends BaseState with EquatableMixin {
  const ScannerState();
}

/// Initial state
class ScannerInitial extends ScannerState {
  const ScannerInitial();

  @override
  List<Object?> get props => [];
}

/// Loading state
class ScannerLoading extends ScannerState {
  const ScannerLoading();

  @override
  List<Object?> get props => [];
}

/// Loaded state with list
class ScannersLoaded extends ScannerState {
  final List<ScannerEntity> items;

  const ScannersLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

/// Loaded state with single item
class ScannerLoaded extends ScannerState {
  final ScannerEntity item;

  const ScannerLoaded(this.item);

  @override
  List<Object?> get props => [item];
}

/// Error state
class ScannerError extends ScannerState {
  final String message;

  const ScannerError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Empty state
class ScannerEmpty extends ScannerState {
  const ScannerEmpty();

  @override
  List<Object?> get props => [];
}
