// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:onboard/presentation/splash/splash_constants.dart';
import 'package:framework/framework.dart';
import 'package:onboard/domain/usecases/health_check_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:network/network.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import 'package:onboard/presentation/splash/splash_action.dart';
import 'package:onboard/presentation/splash/splash_event.dart';
import 'package:onboard/presentation/splash/splash_state.dart';

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
    final result = results[0] as Either<Failure, BaseResponseObject<dynamic>>;

    result.fold(
      (failure) {
        emit(SplashError(message: failure.message, showRestartWarning: true));
        emitEvent(ShowErrorMessageEvent(failure.message));
      },
      (success) {
        emit(const SplashSuccess());
        emitEvent(const NavigateToNextEvent());
      },
    );
  }
}
