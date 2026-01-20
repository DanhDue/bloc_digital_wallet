// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animated_visibility/animated_visibility.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bloc_digital_wallet/app_router.dart';
import 'package:bloc_digital_wallet/config/theme/app_themes.dart';
import 'package:bloc_digital_wallet/di/injection.dart';
import 'package:bloc_digital_wallet/generated/assets.gen.dart';
import 'package:bloc_digital_wallet/generated/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';

import 'splash_action.dart';
import 'splash_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

/// ============================================================================
/// Splash Page
/// ============================================================================

@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SplashBloc>()..onAction(const InitSplashAction()),
      child: const _SplashView(),
    );
  }
}

class _SplashView extends StatefulWidget {
  const _SplashView();

  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView> {
  @override
  void initState() {
    super.initState();
    _listenToEvents();
  }

  void _listenToEvents() {
    context.read<SplashBloc>().events.listen((event) {
      if (!mounted) return;
      _handleEvent(event);
    });
  }

  void _handleEvent(SplashEvent event) {
    switch (event) {
      case NavigateToNextEvent():
        context.router.replace(const LoginRoute());
        break;
      case ShowErrorMessageEvent(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: context.appThemes.errorColor),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<SplashBloc, SplashState>(
          builder: (context, state) {
            final isAnimating = switch (state) {
              SplashInitial() => false,
              SplashLoading(:final isAnimationPlaying) => isAnimationPlaying,
              SplashSuccess() => false,
              SplashError() => false,
            };

            final showRestartWarning = switch (state) {
              SplashInitial() => false,
              SplashLoading(:final showRestartWarning) => showRestartWarning,
              SplashSuccess() => false,
              SplashError(:final showRestartWarning) => showRestartWarning,
            };

            return AnimatedVisibility(
              visible: true,
              enter: fadeIn() + scaleIn(),
              exit: fadeOut() + scaleOut(),
              enterDuration: const Duration(milliseconds: 500),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RepaintBoundary(
                      child: Assets.lotties.digitalWallet.lottie(
                        width: double.infinity,
                        fit: BoxFit.cover,
                        animate: isAnimating,
                        repeat: true,
                        backgroundLoading: true,
                      ),
                    ),
                    OffsetText(
                      mode: AnimationMode.reverse,
                      text: context.t.digitalWallet,
                      duration: const Duration(milliseconds: 500),
                      type: AnimationType.letter,
                      slideType: SlideAnimationType.leftRight,
                      textStyle: context.appThemes.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildStatusText(context, showRestartWarning),
                    const SizedBox(height: 136),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusText(BuildContext context, bool showRestartWarning) {
    final text = showRestartWarning
        ? context.t.restartServiceWarning
        : context.t.serviceHealthChecking;

    return AnimatedTextKit(
      repeatForever: true,
      animatedTexts: [
        ColorizeAnimatedText(
          text,
          textStyle: context.appThemes.bodyMedium,
          textAlign: TextAlign.center,
          colors: [
            context.appThemes.textSecondaryColor,
            context.appThemes.errorColor,
            context.appThemes.textSecondaryColor,
          ],
        ),
      ],
    );
  }
}
