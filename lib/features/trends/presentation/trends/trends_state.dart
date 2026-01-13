// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/entities/trends_entity.dart';

/// States for Trends feature
sealed class TrendsState extends BaseState with EquatableMixin {
  const TrendsState();
}

/// Initial state
class TrendsInitial extends TrendsState {
  const TrendsInitial();

  @override
  List<Object?> get props => [];
}

/// Loading state
class TrendsLoading extends TrendsState {
  const TrendsLoading();

  @override
  List<Object?> get props => [];
}

/// Loaded state with list
class TrendssLoaded extends TrendsState {
  final List<TrendsEntity> items;

  const TrendssLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

/// Loaded state with single item
class TrendsLoaded extends TrendsState {
  final TrendsEntity item;

  const TrendsLoaded(this.item);

  @override
  List<Object?> get props => [item];
}

/// Error state
class TrendsError extends TrendsState {
  final String message;

  const TrendsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Empty state
class TrendsEmpty extends TrendsState {
  const TrendsEmpty();

  @override
  List<Object?> get props => [];
}
