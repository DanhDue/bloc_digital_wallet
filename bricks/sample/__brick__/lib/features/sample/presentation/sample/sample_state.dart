// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/entities/sample_entity.dart';

/// States for Sample feature
sealed class SampleState extends BaseState with EquatableMixin {
  const SampleState();
}

/// Initial state - app just started
class SampleInitial extends SampleState {
  const SampleInitial();

  @override
  List<Object?> get props => [];
}

/// Loading state - fetching data
class SampleLoading extends SampleState {
  const SampleLoading();

  @override
  List<Object?> get props => [];
}

/// Loaded state with list of items
class SamplesLoaded extends SampleState {
  final List<SampleEntity> items;

  const SamplesLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

/// Loaded state with single item
class SampleLoaded extends SampleState {
  final SampleEntity item;

  const SampleLoaded(this.item);

  @override
  List<Object?> get props => [item];
}

/// Empty state - no items found
class SampleEmpty extends SampleState {
  const SampleEmpty();

  @override
  List<Object?> get props => [];
}

/// Error state - something went wrong
class SampleError extends SampleState {
  final String message;

  const SampleError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Creating state - item is being created
class SampleCreating extends SampleState {
  const SampleCreating();

  @override
  List<Object?> get props => [];
}

/// Created state - item was created successfully
class SampleCreated extends SampleState {
  final SampleEntity item;

  const SampleCreated(this.item);

  @override
  List<Object?> get props => [item];
}

/// Deleting state - item is being deleted
class SampleDeleting extends SampleState {
  final String id;

  const SampleDeleting(this.id);

  @override
  List<Object?> get props => [id];
}
