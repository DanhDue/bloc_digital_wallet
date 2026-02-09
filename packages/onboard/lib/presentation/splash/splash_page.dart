// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:animated_visibility/animated_visibility.dart';
import 'package:auto_route/auto_route.dart';
import 'package:core/utils/feature_public_routes.dart';
import 'package:core/core.dart';

import 'package:onboard/generated/translations.dart';

import 'package:framework/framework.dart';

import 'splash_constants.dart';
import 'package:ui_kit/ui_kit.dart';

import 'package:flutter/material.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';

import 'splash_action.dart';
import 'splash_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

/// ============================================================================
/// Splash Page - Using BaseMviPage pattern
/// ============================================================================

@RoutePage()
class SplashPage extends BaseMviPage<SplashBloc, SplashAction, SplashState, SplashEvent> {
  const SplashPage({super.key});

  @override
  void Function(SplashBloc bloc)? get onBlocCreated =>
      (bloc) => bloc.onAction(const InitSplashAction());

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildScaffold(BuildContext context) {
    // Override to center the body content
    return Scaffold(body: Center(child: buildBody(context)));
  }

  @override
  Widget handleState(BuildContext context, SplashState state) {
    final isAnimating = switch (state) {
      SplashInitial() => false,
      SplashLoading(:final isAnimationPlaying) => isAnimationPlaying,
      SplashSuccess() => false,
      SplashError() => false,
    };

    final isVisible = switch (state) {
      SplashInitial() => false,
      SplashLoading(:final isAnimationVisible) => isAnimationVisible,
      SplashSuccess() => true,
      SplashError() => true,
    };

    final showRestartWarning = switch (state) {
      SplashInitial() => false,
      SplashLoading(:final showRestartWarning) => showRestartWarning,
      SplashSuccess() => false,
      SplashError(:final showRestartWarning) => showRestartWarning,
    };

    return AnimatedVisibility(
      visible: isVisible,
      enter: scaleIn(),
      exit: scaleOut(),
      enterDuration: SplashConstants.containerEnterDuration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              // Invisible placeholder to maintain size during animation
              Opacity(
                opacity: 0,
                child: Padding(
                  padding: .symmetric(horizontal: 36),
                  child: Assets.lotties.digitalWallet.lottie(width: .infinity, fit: .cover),
                ),
              ),
              // Animated content
              AnimatedVisibility(
                visible: isVisible,
                enter: fadeIn() + scaleIn(),
                exit: fadeOut() + scaleOut(),
                enterDuration: SplashConstants.lottieEnterDuration,
                child: Padding(
                  padding: .symmetric(horizontal: 36),
                  child: RepaintBoundary(
                    child: Assets.lotties.digitalWallet.lottie(
                      width: .infinity,
                      fit: .cover,
                      animate: isAnimating,
                      repeat: true,
                      backgroundLoading: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
          OffsetText(
            mode: AnimationMode.reverse,
            text: context.tOnboard.digitalWallet,
            duration: SplashConstants.titleDuration,
            type: AnimationType.letter,
            slideType: SlideAnimationType.leftRight,
            textStyle: context.appThemes.headlineLarge.copyWith(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatusText(context, showRestartWarning),
          const SizedBox(height: 136),
        ],
      ),
    );
  }

  @override
  void handleEvent(BuildContext context, SplashEvent event) {
    switch (event) {
      case NavigateToNextEvent():
        // Navigate to Transaction via FeaturePublicRoutes (avoids direct package import)
        context.router.replace(FeaturePublicRoutes.trendsRoute);
        Log.d("NavigateToNextEvent");
        break;
      case ShowErrorMessageEvent(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: context.appThemes.errorColor),
        );
        break;
    }
  }

  Widget _buildStatusText(BuildContext context, bool showRestartWarning) {
    final text = showRestartWarning
        ? context.tOnboard.restartServiceWarning
        : context.tOnboard.serviceHealthChecking;

    return BlinkText(
      text,
      style: context.appThemes.bodyLarge,
      beginColor: context.appThemes.textSecondaryColor,
      endColor: context.appThemes.errorColor,
      textAlign: TextAlign.center,
    );
  }
}
