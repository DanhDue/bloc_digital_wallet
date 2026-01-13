// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/entities/home_entity.dart';

/// States for Home feature
/// For bottom navigation, we use a single state that includes currentTabIndex
sealed class HomeState extends BaseState with EquatableMixin {
  const HomeState();

  /// Get current tab index (default 0)
  int get currentTabIndex => 0;
}

/// Main home state with tab navigation
class HomeNavigationState extends HomeState {
  @override
  final int currentTabIndex;

  const HomeNavigationState({this.currentTabIndex = 0});

  HomeNavigationState copyWith({int? currentTabIndex}) {
    return HomeNavigationState(currentTabIndex: currentTabIndex ?? this.currentTabIndex);
  }

  @override
  List<Object?> get props => [currentTabIndex];
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
