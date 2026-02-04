// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:equatable/equatable.dart';
import 'package:framework/framework.dart';

/// ============================================================================
/// Splash States
/// ============================================================================

sealed class SplashState extends BaseState with EquatableMixin {
  const SplashState();
}

/// Initial state - the starting point
class SplashInitial extends SplashState {
  const SplashInitial();

  @override
  List<Object?> get props => [];
}

/// Loading state - health check in progress
class SplashLoading extends SplashState {
  final bool isAnimationVisible;
  final bool isAnimationPlaying;
  final bool showRestartWarning;

  const SplashLoading({
    this.isAnimationVisible = true,
    this.isAnimationPlaying = true,
    this.showRestartWarning = false,
  });

  SplashLoading copyWith({
    bool? isAnimationVisible,
    bool? isAnimationPlaying,
    bool? showRestartWarning,
  }) {
    return SplashLoading(
      isAnimationVisible: isAnimationVisible ?? this.isAnimationVisible,
      isAnimationPlaying: isAnimationPlaying ?? this.isAnimationPlaying,
      showRestartWarning: showRestartWarning ?? this.showRestartWarning,
    );
  }

  @override
  List<Object?> get props => [isAnimationVisible, isAnimationPlaying, showRestartWarning];
}

/// Success state - health check passed
class SplashSuccess extends SplashState {
  const SplashSuccess();

  @override
  List<Object?> get props => [];
}

/// Error state - health check failed
class SplashError extends SplashState {
  final String message;
  final bool showRestartWarning;

  const SplashError({required this.message, this.showRestartWarning = true});

  @override
  List<Object?> get props => [message, showRestartWarning];
}
