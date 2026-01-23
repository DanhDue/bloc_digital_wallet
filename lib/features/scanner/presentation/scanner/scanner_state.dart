// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// Scanner States
/// ============================================================================
/// States represent the UI state at any given moment.
///
/// HOW TO EXTEND:
/// 1. Add new state classes for different UI states (e.g., Loading, Success, Error)
/// 2. Each state should extend ScannerState
/// 3. Include relevant data in each state class
///
/// EXAMPLE - Adding Loading and Success states:
/// ```dart
/// class ScannerLoading extends ScannerState {
///   const ScannerLoading();
///   @override
///   List<Object?> get props => [];
/// }
///
/// class ScannerSuccess extends ScannerState {
///   final List<YourEntity> items;
///   const ScannerSuccess(this.items);
///   @override
///   List<Object?> get props => [items];
/// }
/// ```
/// ============================================================================

sealed class ScannerState extends BaseState with EquatableMixin {
  const ScannerState();
}

/// Initial state - the starting point
class ScannerInitial extends ScannerState {
  const ScannerInitial();

  @override
  List<Object?> get props => [];
}
