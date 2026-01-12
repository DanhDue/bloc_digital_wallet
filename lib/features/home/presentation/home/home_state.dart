// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/entities/home_entity.dart';

/// States for Home feature
sealed class HomeState extends BaseState with EquatableMixin {
  const HomeState();
}

/// Initial state
class HomeInitial extends HomeState {
  const HomeInitial();

  @override
  List<Object?> get props => [];
}

/// Loading state
class HomeLoading extends HomeState {
  const HomeLoading();

  @override
  List<Object?> get props => [];
}

/// Loaded state with list
class HomesLoaded extends HomeState {
  final List<HomeEntity> items;

  const HomesLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

/// Loaded state with single item
class HomeLoaded extends HomeState {
  final HomeEntity item;

  const HomeLoaded(this.item);

  @override
  List<Object?> get props => [item];
}

/// Error state
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Empty state
class HomeEmpty extends HomeState {
  const HomeEmpty();

  @override
  List<Object?> get props => [];
}
