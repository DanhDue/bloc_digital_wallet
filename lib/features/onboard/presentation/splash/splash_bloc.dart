// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_digital_wallet/features/onboard/presentation/splash/splash_constants.dart';
import 'package:bloc_digital_wallet/core/architecture/architecture.dart';
import 'package:bloc_digital_wallet/features/onboard/domain/usecases/health_check_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'splash_action.dart';
import 'splash_event.dart';
import 'splash_state.dart';

/// ============================================================================
/// Splash BLoC
/// ============================================================================

@injectable
class SplashBloc extends MviBloc<SplashAction, SplashState, SplashEvent> {
  final HealthCheckUseCase _healthCheckUseCase;

  SplashBloc(this._healthCheckUseCase) : super(const SplashInitial()) {
    handleActionDroppable<InitSplashAction>(_onInit);
    handleActionDroppable<RetryHealthCheckAction>(_onRetryHealthCheck);
  }

  @override
  void onAction(SplashAction action) {
    add(action);
  }

  Future<void> _onInit(InitSplashAction action, Emitter<SplashState> emit) async {
    // Start with visibility false to trigger AnimatedVisibility enter animation
    emit(
      const SplashLoading(
        isAnimationVisible: false,
        isAnimationPlaying: false,
        showRestartWarning: false,
      ),
    );

    // Short delay to allow first frame, then trigger AnimatedVisibility
    await Future.delayed(SplashConstants.visibilityDelay);

    emit(
      const SplashLoading(
        isAnimationVisible: true,
        isAnimationPlaying: false,
        showRestartWarning: false,
      ),
    );

    // Wait for outer AnimatedVisibility to complete before starting lottie
    await Future.delayed(SplashConstants.lottieDelay);

    emit(
      const SplashLoading(
        isAnimationVisible: true,
        isAnimationPlaying: true,
        showRestartWarning: false,
      ),
    );

    await _performHealthCheck(emit);
  }

  Future<void> _onRetryHealthCheck(
    RetryHealthCheckAction action,
    Emitter<SplashState> emit,
  ) async {
    final currentState = state;
    if (currentState is SplashLoading) {
      emit(currentState.copyWith(showRestartWarning: false));
    } else {
      emit(
        const SplashLoading(
          isAnimationVisible: true,
          isAnimationPlaying: true,
          showRestartWarning: false,
        ),
      );
    }

    await _performHealthCheck(emit);
  }

  Future<void> _performHealthCheck(Emitter<SplashState> emit) async {
    // Run health check and minimum delay in parallel
    // Wait for both to complete before proceeding
    final results = await Future.wait([
      _healthCheckUseCase(),
      Future.delayed(SplashConstants.minSplashDuration),
    ]);

    // Get the health check result (first item in the list)
    final result = results[0];

    result.fold(
      (failure) {
        final currentState = state;
        final errorMessage = failure.message;
        if (currentState is SplashLoading) {
          emit(currentState.copyWith(showRestartWarning: true));
        } else {
          emit(SplashError(message: errorMessage, showRestartWarning: true));
        }
        emitEvent(ShowErrorMessageEvent(errorMessage));
      },
      (response) {
        emit(const SplashSuccess());
        emitEvent(const NavigateToNextEvent());
      },
    );
  }
}
