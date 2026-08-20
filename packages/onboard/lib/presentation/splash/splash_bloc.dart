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

import 'package:settings/settings.dart';
import 'package:onboard/presentation/splash/splash_action.dart';
import 'package:onboard/presentation/splash/splash_event.dart';
import 'package:onboard/presentation/splash/splash_state.dart';

/// ============================================================================
/// Splash BLoC
/// ============================================================================

@injectable
class SplashBloc extends MviBloc<SplashAction, SplashState, SplashEvent> {
  final HealthCheckUseCase _healthCheckUseCase;
  final BootstrapUseCase _bootstrapUseCase;
  final LoadBundledFallbackUseCase _loadBundledFallbackUseCase;
  final FetchTranslationUseCase _fetchTranslationUseCase;

  SplashBloc(
    this._healthCheckUseCase,
    this._bootstrapUseCase,
    this._loadBundledFallbackUseCase,
    this._fetchTranslationUseCase,
  ) : super(const SplashInitial()) {
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

    await _performBootstrapAndHealthCheck(emit);
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

    await _performBootstrapAndHealthCheck(emit);
  }

  Future<void> _performBootstrapAndHealthCheck(Emitter<SplashState> emit) async {
    // 1. Always load bundled fallback first
    final currentLocale = LocalizationManager.instance.currentLocale.languageCode;
    final fallbackResult = await _loadBundledFallbackUseCase(currentLocale);
    if (fallbackResult.isRight()) {
      final jsonMap = fallbackResult.getOrElse(() => {});
      await LocalizationManager.instance.applyDynamicTranslations(jsonMap);
    }

    // 2. Perform bootstrap and health check
    final results = await Future.wait([
      _bootstrapUseCase().timeout(
        const Duration(seconds: 5),
        onTimeout: () => const Left(ServerFailure(message: 'Timeout')),
      ),
      _healthCheckUseCase(),
      Future.delayed(SplashConstants.minSplashDuration),
    ]);

    final bootstrapResult = results[0] as Either<Failure, SyncBootstrapResponse>;
    final healthResult = results[1] as Either<Failure, BaseResponseObject<dynamic>>;

    // Process Bootstrap Result
    if (bootstrapResult.isRight()) {
      final response = bootstrapResult.getOrElse(() => throw Exception('unreachable'));

      // Update language if preference exists
      final selectedLanguage = response.userPreferences?.selectedLanguage;
      if (selectedLanguage != null) {
        await LocalizationManager.instance.setLocaleFromCode(selectedLanguage);
      }

      // Fetch stale translations
      for (final translationItem in response.translations ?? []) {
        await _fetchTranslationUseCase(translationItem);
      }

      // Note: Purging deleted translation keys logic can be added later
    } else {
      // On failure or timeout, just proceed with cached/fallback data.
      // E.g. we might want to load cached translations if they exist, but fallback is already loaded.
    }

    healthResult.fold(
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
