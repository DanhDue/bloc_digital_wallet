// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';

/// Common UI states used across features
abstract class UiState extends Equatable {
  const UiState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any action
class InitialState extends UiState {
  const InitialState();
}

/// Loading state while processing
class LoadingState extends UiState {
  final String? message;

  const LoadingState([this.message]);

  @override
  List<Object?> get props => [message];
}

/// Success state with optional data
class SuccessState<T> extends UiState {
  final T? data;
  final String? message;

  const SuccessState({this.data, this.message});

  @override
  List<Object?> get props => [data, message];
}

/// Error state with error details
class ErrorState extends UiState {
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;

  const ErrorState({required this.message, this.error, this.stackTrace});

  @override
  List<Object?> get props => [message, error, stackTrace];
}

/// Empty state when no data is available
class EmptyState extends UiState {
  final String? message;

  const EmptyState([this.message]);

  @override
  List<Object?> get props => [message];
}

/// Loaded state with data
class LoadedState<T> extends UiState {
  final T data;

  const LoadedState(this.data);

  @override
  List<Object?> get props => [data];
}
